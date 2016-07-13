module ColumnTypes
  extend ActiveSupport::Concern

  included do
    (ColumnTypes::String.methods - Object.methods).each do |m|
      define_method(m) do |v = nil|
        type = ColumnTypes.const_get(column_type.classify) rescue ColumnTypes::String
        type.send(m, v.to_s.normalize_charwidth.strip, self)
      end
    end
  end

  class String
    NAME    = "文字列"
    DB_TYPE = :string

    def self.label(*args)        self::NAME end
    def self.db_type(*args)      self::DB_TYPE end
    def self.filter(v, *args)     v end
    def self.valid(v, *args)      true end

    def self.selector?(*args)    false end
    def self.def_selector(*args) [] end

    def self.numeric?(*args)     false end
    def self.datetime?(*args)    false end
    def self.id?(*args)          false end

    def self.ransack_null?(*args)
      numeric? || datetime? || id?
    end
  end

  class SumString < ColumnTypes::String
    NAME = "文字列(集計対象)"
  end

  class Text < ColumnTypes::String
    NAME    = "テキスト"
    DB_TYPE = :text
  end

  class Integer < ColumnTypes::String
    NAME    = "整数"
    DB_TYPE = :integer

    def self.filter(v, *args) v.gsub(/[,、]/, "") end
    def self.valid(v, *args)  Integer(v) rescue false end

    def self.numeric?(*args)  true end
  end

  class Float < ColumnTypes::Integer
    NAME    = "小数"
    DB_TYPE = :float

    def self.filter(v, *args) v.gsub(/[,、]/, "") end
    def self.valid(v, *args)  Float(v) rescue false end
  end

  class Yen < ColumnTypes::Integer
    NAME = "金額(円)"
  end
  class SenYen < ColumnTypes::Yen
    NAME = "金額(千円)"
  end

  class Datetime < ColumnTypes::String
    NAME     = "日時"
    DB_TYPE = :datetime

    # def self.filter(v, *args)Time.parse(v, *args)rescue "notdate" end
    def self.valid(v, *args)  v != "notdate" end
    def self.datetime?(*args) true end
  end

  class Company < ColumnTypes::String
    NAME = "会社名"

    def self.filter(v, *args) replace_kabu(v) end

    def self.replace_kabu(str)
      str = str.to_s
      {
        /[\((]株[\))]|㈱/ => "株式会社",
        /[\((]有[\))]|㈲/ => "有限会社",
        /[\((]名[\))]|㈴/ => "合名会社",
        /[\((]資[\))]|㈾/ => "合資会社",
        /[\((]医[\))]/    => "医療法人",
        /[\((]財[\))]|㈶/ => "財団法人",
        /[\((]社[\))]|㈳/ => "社団法人",
        /[\((]宗[\))]/    => "宗教法人",
        /[\((]学[\))]|㈻/ => "学校法人",
        /[\((]福[\))]/    => "社会福祉法人",
        /[\((]独[\))]/    => "独立行政法人",
        /[\((]特非[\))]/  => "特定非営利活動法人",
        /[\((]企[\))]|㈽/ => "企業組合",
        /[\((]業[\))]/    => "協業組合",
        /[\((]協[\))]|㈿/ => "事業協同組合",
      }.each { |reg, res| str.gsub!(reg, res) }

      str
    end
  end

  class Zip < ColumnTypes::String
    NAME = "〒"

    def self.filter(v, *args) v.match(/\A([0-9]{3})\-?([0-9]{4})/) { |m| "#{m[1]}-#{m[2]}" } end
    def self.valid(v, *args)  /\A[0-9]{3}\-[0-9]{4}\z/ === v end
  end

  class Address < ColumnTypes::String
    NAME = "住所"
  end

  class Tel < ColumnTypes::String
    NAME = "TEL"
    def self.filter(v, *args) v.gsub(/[^0-9]/, '').sub(/^[^0]/, '0\0') end
  end

  class Mail < ColumnTypes::String
    NAME = "メールアドレス"
    def self.valid(v, *args) /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i === v end
  end

  class Url < ColumnTypes::String
    NAME = "URL"
    def self.valid(v, *args) /\A#{URI::regexp}\z/ === v end
  end

  class Selector < ColumnTypes::String
    NAME = "単数選択"

    def self.selector?(*args)    true end
    def self.valid(v, co, *args) co.selector.split("\n").map(&:strip).include? v end
  end

  class Pref < ColumnTypes::String
    NAME = "都道府県"
    def self.def_selector(*args)
      %w(
        北海道 青森県 秋田県 山形県 岩手県 宮城県 福島県
        栃木県 茨城県 群馬県 埼玉県 東京都 千葉県 神奈川県 山梨県
        新潟県 長野県 富山県 石川県 福井県
        静岡県 愛知県 岐阜県 三重県
        滋賀県 奈良県 京都府 大阪府 兵庫県 和歌山県
        岡山県 広島県 鳥取県 島根県 山口県
        香川県 徳島県 愛媛県 高知県
        福岡県 佐賀県 宮崎県 大分県 長崎県 熊本県 鹿児島県 沖縄県
        海外
      )
    end

    def self.valid(v, *args)def_selector.include? v end
  end

  class Status < ColumnTypes::Pref
    NAME = "ステータス"
    def self.def_selector(*args)
      %w(取引先 案件化済未取引 名刺交換先 問合せ 過去取引先 新規 不明)
    end
  end

  class Target < ColumnTypes::Pref
    NAME = "ターゲット"
    def self.def_selector(*args)
      %w(ターゲット パートナー 仕入業者 競合 その他)
    end
  end

  class Influx < ColumnTypes::Pref
    NAME = "流入経路"
    def self.def_selector(*args)
      %w(紹介 展示会 アウトバウンド ウェブ その他)
    end
  end

  class Sex < ColumnTypes::Pref
    NAME = "性別"
    def self.def_selector(*args)
      %w(男 女 不明)
    end
  end

  class LCategory < ColumnTypes::Pref
    NAME = "業種大分類"
    def self.def_selector(*args)
      %w|A_農業、林業
        B_漁業
        C_鉱業、採石業、砂利採取業
        D_建設業
        E_製造業
        F_電気・ガス・熱供給・水道業
        G_情報通信業
        H_運輸業、郵便業
        I_卸売業、小売業
        J_金融業、保険業
        K_不動産業、物品賃貸業
        L_学術研究、専門・技術サービス業
        M_宿泊業、飲食サービス業
        N_生活関連サービス業、娯楽業
        O_教育、学習支援業
        P_医療、福祉
        Q_複合サービス事業
        R_サービス業(他に分類されないもの)
        S_公務(他に分類されるものを除く)
        T_分類不能の産業
      |
    end
  end

  class MCategory < ColumnTypes::Pref
    NAME = "業種中分類"
    def self.def_selector(*args)
      %w|01_農業
        02_林業
        03_漁業(水産養殖業を除く)
        04_水産養殖業
        05_鉱業、採石業、砂利採取業
        06_総合工事業
        07_職別工事業(設備工事業を除く)
        08_設備工事業
        09_食料品製造業
        10_飲料・たばこ・飼料製造業
        11_繊維工業
        12_木材・木製品製造業(家具を除く)
        13_家具・装備品製造業
        14_パルプ・紙・紙加工品製造業
        15_印刷・同関連業
        16_化学工業
        17_石油製品・石炭製品製造業
        18_プラスチック製品製造業(別掲を除く)
        19_ゴム製品製造業
        20_なめし革・同製品・毛皮製造業
        21_窯業・土石製品製造業
        22_鉄鋼業
        23_非鉄金属製造業
        24_金属製品製造業
        25_はん用機械器具製造業
        26_生産用機械器具製造業
        27_業務用機械器具製造業
        28_電子部品・デバイス・電子回路製造業
        29_電気機械器具製造業
        30_情報通信機械器具製造業
        31_輸送用機械器具製造業
        32_その他の製造業
        33_電気業
        34_ガス業
        35_熱供給業
        36_水道業
        37_通信業
        38_放送業
        39_情報サービス業
        40_インターネット附随サービス業
        41_映像・音声・文字情報制作業
        42_鉄道業
        43_道路旅客運送業
        44_道路貨物運送業
        45_水運業
        46_航空運輸業
        47_倉庫業
        48_運輸に附帯するサービス業
        49_郵便業(信書便事業を含む)
        50_各種商品卸売業
        51_繊維・衣服等卸売業
        52_飲食料品卸売業
        53_建築材料、鉱物・金属材料等卸売業
        54_機械器具卸売業
        55_その他の卸売業
        56_各種商品小売業
        57_織物・衣服・身の回り品小売業
        58_飲食料品小売業
        59_機械器具小売業
        60_その他の小売業
        61_無店舗小売業
        62_銀行業
        63_協同組織金融業
        64_貸金業、クレジットカード業等非預金信用機関
        65_金融商品取引業、商品先物取引業
        66_補助的金融業等
        67_保険業(保険媒介代理業、保険サービス業を含む)
        68_不動産取引業
        69_不動産賃貸業・管理業
        70_物品賃貸業
        71_学術・開発研究機関
        72_専門サービス業(他に分類されないもの)
        73_広告業
        74_技術サービス業(他に分類されないもの)
        75_宿泊業
        76_飲食店
        77_持ち帰り・配達飲食サービス業
        78_洗濯・理容・美容・浴場業
        79_その他の生活関連サービス業
        80_娯楽業
        81_学校教育
        82_その他の教育、学習支援業
        83_医療業
        84_保健衛生
        85_社会保険・社会福祉・介護事業
        86_郵便局
        87_協同組合(他に分類されないもの)
        88_廃棄物処理業
        89_自動車整備業
        90_機械等修理業(別掲を除く)
        91_職業紹介・労働者派遣業
        92_その他の事業サービス業
        93_政治・経済・文化団体
        94_宗教
        95_その他のサービス業
        96_外国公務
        97_国家公務
        98_地方公務
        99_分類不能の産業
      |
    end
  end

  class Id < ColumnTypes::Integer
    NAME = "ID"
    def self.id?(*args) true end
  end
end
