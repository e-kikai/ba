module ColumnTypes
  class String
    NAME    = "文字列"
    DB_TYPE = :string

    def self.label()    self::NAME end
    def self.db_type() self::DB_TYPE end

    def self.filter(v) v end
    def self.valid(v)  v end
    def self.format(v) v end
    def self.detail_format(v) self.format(v) end

    def self.selector?() false end
    def self.default_selector() [] end
  end

  class Text < ColumnTypes::String
    NAME    = "テキスト"
    DB_TYPE = :text
  end

  class Integer < ColumnTypes::String
    NAME    = "整数"
    DB_TYPE = :integer

    # def self.filter(v) v.gsub(/[,、]/, "") end
    def self.valid(v)  Integer(v) rescue false end
    def self.format(v) v.to_i.to_s(:delimited) end
  end

  class Float < ColumnTypes::Integer
    NAME    = "小数"
    DB_TYPE = :float

    def self.valid(v) Float(v) rescue false end
    def self.format(v) v.to_f.to_s(:delimited) end
  end

  class Datetime < ColumnTypes::String
    NAME     = "日時"
    DB_TYPE = :datetime

    # def self.filter(v) Time.parse(v) rescue "notdate" end
    def self.valid(v)  v != "notdate" end
  end

  class Company < ColumnTypes::String
    NAME = "会社名"

    def self.filter(v) replace_kabu(v) end
    def self.format(v) replace_kabu(v).presence || "(UNKNOWN)" end

    private

    def self.replace_kabu(str)
      str = str.to_s
      {
        /[\(（]株[\)）]|㈱/ => "株式会社",
        /[\(（]有[\)）]|㈲/ => "有限会社",
        /[\(（]名[\)）]|㈴/ => "合名会社",
        /[\(（]資[\)）]|㈾/ => "合資会社",
        /[\(（]医[\)）]/    => "医療法人",
        /[\(（]財[\)）]|㈶/ => "財団法人",
        /[\(（]社[\)）]|㈳/ => "社団法人",
        /[\(（]宗[\)）]/    => "宗教法人",
        /[\(（]学[\)）]|㈻/ => "学校法人",
        /[\(（]福[\)）]/    => "社会福祉法人",
        /[\(（]独[\)）]/    => "独立行政法人",
        /[\(（]特非[\)）]/  => "特定非営利活動法人",
        /[\(（]企[\)）]|㈽/ => "企業組合",
        /[\(（]業[\)）]/    => "協業組合",
        /[\(（]協[\)）]|㈿/ => "事業協同組合",
      }.each { |reg, res| str.gsub!(reg, res) }

      str
    end
  end

  class Zip < ColumnTypes::String
    NAME = "〒"

    def self.filter(v) v.match(/\A([0-9]{3})\-?([0-9]{4})/) { |m| "#{m[1]}-#{m[2]}" } end
    def self.valid(v)  v =~ /\A[0-9]{3}\-[0-9]{4}\z/ end
    def self.format(v) v.match(/\A([0-9]{3})\-?([0-9]{4})/) { |m| "#{m[1]}-#{m[2]}" } end
  end

  class Address < ColumnTypes::String
    NAME = "住所"

    def self.detail_format(v)
      if v.present?
        ("#{v} " + ActionController::Base.helpers.link_to("https://maps.google.co.jp/maps?f=q&q=#{v}&source=embed&hl=ja&geocode=&ie=UTF8&t=m&z=14", target: "_blank") do
          '<span class="glyphicon glyphicon-map-marker"></span> MAP'.html_safe
        end).html_safe
      end
    end
  end

  class Tel < ColumnTypes::String
    NAME = "TEL"
    def self.filter(v) v.gsub(/[^0-9]/, '').sub(/^[^0]/, '0\0') end
  end

  class Mail < ColumnTypes::String
    NAME = "メールアドレス"
    def self.valid(v)         v =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i end
    def self.detail_format(v) ActionController::Base.helpers.mail_to(v) end
  end

  class Url < ColumnTypes::String
    NAME = "URL"
    def self.valid(v)         v =~ /\A#{URI::regexp}\z/ end
    def self.detail_format(v) ActionController::Base.helpers.link_to(v, v, target: "_blank") end
  end

  class Selector < ColumnTypes::String
    NAME = "単数選択"

    def self.selector?() true end
  end

  class Pref < ColumnTypes::String
    NAME = "都道府県"
    def self.default_selector
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

    def self.valid(v) default_selector.include? v end
  end

  class Status < ColumnTypes::Pref
    NAME = "ステータス"
    def self.default_selector
      %w(取引先 案件化済未取引 名刺交換先 問合せ 過去取引先 新規 不明)
    end
  end

  class Target < ColumnTypes::Pref
    NAME = "ターゲット"
    def self.default_selector
      %w(ターゲット パートナー 仕入業者 競合 その他)
    end
  end

  class Influx < ColumnTypes::Pref
    NAME = "流入経路"
    def self.default_selector
      %w(紹介 展示会 アウトバウンド ウェブ その他)
    end
  end

  class Sex < ColumnTypes::Pref
    NAME = "性別"
    def self.default_selector
      %w(男 女 不明)
    end
  end

  class Id < ColumnTypes::Integer
    NAME = "ID"
    def self.format(v) v end
  end
end
