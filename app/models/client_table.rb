class ClientTable < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  validates :client_id,  presence: true
  validates :name,       presence: true
  validates :table_name, presence: true

  belongs_to :client
  has_many   :client_columns
  accepts_nested_attributes_for :client_columns, allow_destroy: true, reject_if: :check_name

  before_create :create_client_table_before

  CONDITIONS = { "を含む" => "cont", "を含まない" => "not_cont", "で一致" => "eq", "で一致しない" => "not_eq",
    "から始まる" => "start", "から始まらない" => "not_start", "で終わる" => "end", "で終わらない" => "not_end",
    "空白" => "blank", "空白でない" => "present",
    "のいずれかを含む(空白区切り)" => "cont_any", "のいずれかを含まない(空白区切り)" => "not_cont_any",
    "のいずれかに一致(空白区切り)" => "in", "のいずれか一致しない(空白区切り)" => "not_in",
    "以下" => "lteq", "以上" => "gteq", "より小さい" => "lt", "より大きい" => "gt",
    "重複している" => "overlap", "重複していない" => "unique",
  }

  NUM_CONDITIONS = %w(eq not_eq blank present in not_in lteq gteq lt gt overlap unique).map { |v| self::CONDITIONS.rassoc(v) }.compact.to_h

  COND_ARRAYS   = %w(in not_in cont_any not_cont_any)
  COND_PRESENTS = %w(present blank)
  COND_UNIQUES  = %w(overlap unique)
  COND_NOVALS   = self::COND_PRESENTS + self::COND_UNIQUES

  # 会社テーブルとデフォルトカラム生成
  #
  # @param [Iinteger]     client_id クライアントID
  # @return [ClientTable] 生成した会社テーブル
  def self.create_company_table(client_id)
    co = self.create(client_id: client_id, name: "会社", table_name: "c#{client_id}_companies", company: true)

    co.client_columns.create(name: "会社名",         column_name: :name,    column_type: :company, order_no: 100)
    co.client_columns.create(name: "都道府県",       column_name: :pref,    column_type: :pref,    order_no: 200)
    co.client_columns.create(name: "TEL",            column_name: :tel,     column_type: :tel,     order_no: 300)
    co.client_columns.create(name: "FAX",            column_name: :fax,     column_type: :tel,     order_no: 400)
    co.client_columns.create(name: "〒",             column_name: :zip,     column_type: :zip,     order_no: 500)
    co.client_columns.create(name: "住所",           column_name: :address, column_type: :address, order_no: 600)
    co.client_columns.create(name: "メールアドレス", column_name: :mail,    column_type: :mail,    order_no: 700)
    co.client_columns.create(name: "URL",            column_name: :url,     column_type: :url,     order_no: 800)
    co.client_columns.create(name: "ステータス",     column_name: :status,  column_type: :status,  order_no: 900)
    co.client_columns.create(name: "ターゲット",     column_name: :target,  column_type: :target,  order_no: 1000)
    co.client_columns.create(name: "流入経路",       column_name: :influx,  column_type: :influx,  order_no: 1100)

    co
  end

  # 子テーブルとデフォルトカラム生成
  #
  # @param  [Iinteger]    client_id クライアントID
  # @param  [String]      name テーブル名
  # @return [ClientTable] 生成した子テーブル
  def self.create_chiid_table(client_id, name)
    ch = self.create(client_id: client_id, name: name, table_name: "c#{client_id}_#{Time.now.strftime('%Y%m%d%H%M%S')}", company: false)

    ch.client_columns.create(name: "#{name}名", column_name: :name,       column_type: :string, order_no: 100)
    ch.client_columns.create(name: "会社ID",    column_name: :company_id, column_type: :id,     order_no: 200)

    ch
  end

  # テーブル構成の複製
  #
  # @param  [Iinteger]    client_id クライアントID
  # @param  [Iinteger]    template_id コピー元のクライアントID
  # @return [boolean]     true
  def self.clone_tables(client_id, template_id)
    temp_client = Client.find(template_id)

    temp_client.client_tables.each do |t|
      t.clone_table(client_id)
    end

    true
  end

  # 他のclientのテーブル構成を複製
  #
  # @param [Integer] 複製先のclient_id
  def clone_table(client_id)
    clone_name = table_name.sub(/([0-9]+)/, client_id.to_s)
    table      = ClientTable.create(client_id: client_id, name: name, table_name: clone_name, company: company)

    client_columns.each do |co|
      column = co.dup
      column.client_table_id = table.id
      column.save
    end
  end

  # 表示用のカラム一覧
  def show_columns
    client_columns.show
  end

  def columns_options
    ([["ID", "id"]] + show_columns.pluck(:name, :column_name) + [["登録日時", "created_at"], ["変更日時", "updated_at"]]).to_h
  end

  # client_table_dataクラスを取得
  #
  # @param  [Boolean] refresh クラスを更新するかどうか
  # @return [ClentTableData] このclient_tableのclient_table_dataクラス
  def klass(refresh = false)
    if refresh || !Object.const_defined?(table_name.singularize.camelcase)
      client_table = self
      Object.const_set(table_name.singularize.camelcase, Class.new(ActiveRecord::Base) do |klass|
        include ClientTableDataModule
        klass.table_name = client_table.table_name

        klass.reset_column_information
      end)
    else
      Object.const_get(table_name.singularize.camelcase)
    end
  end

  def filter(data)
    client_columns.each do |co|
      if data[co.column_name].present?
        data[co.column_name] = co.filter(data[co.column_name]).to_s.normalize_charwidth.strip
      end
    end
    data
  end

  # 会社テーブルかどうか
  #
  # @return [Boolean] 会社テーブルならばtrue
  def company?
    company ? true : false
  end

  def company_id_column
    client_columns.find_by(column_name: :company_id)
  end

  # アップロードされたファイルをスプレッドシート展開
  #
  # @param  [string] path              tmpファイルパス
  # @param  [string] original_filename 元ファイル名
  # @return [Spreadseet]               スプレッドシートオブジェクト
  def spreadsheet(path, original_filename)
    case File.extname(original_filename)
    when '.csv'  then Roo::CSV.new(path, csv_options: {encoding: Encoding::SJIS})
    when '.xls'  then Roo::Excel.new(path)
    when '.xlsx' then Roo::Excelx.new(path)
    when '.ods'  then Roo::OpenOffice.new(path)
    else raise "不明なファイルタイプです: #{original_filename}"
    end
  end

  # # アップロードされたファイルを一時ファイルに情報を格納
  # #
  # # @param  [file]   file アップロードファイルオブジェクト
  # # @return [string] アップロードしたファイルのパス
  # def import_file(file)
  #   temp = Tempfile.open('csv_').binmode
  #   temp.write(File.new(file.path, "rb").read)
  #   temp.path
  # end

  # 項目設定の整理し、設定がされているかチェック
  #
  # @param [Hash] params 入力パラメータ
  # @return [Hash] 整理した項目設定
  def import_check(params)
    matchings = []
    params[:table_header].each do |i, h|
      matchings << {table_header: h, i: i.to_i } if h.present? && params[:method][i] == "matching"
    end

    matchings
  end

  # マッチングして保存
  #
  # @param [Hash]  params 入力パラメータ
  # @param [Array] matchings 整理した項目設定
  # @return self
  def import(params, import_file)
    errors    = []
    ctd       = klass.arel_table

    matchings = import_check(params)

    # ss        = spreadsheet(import_file[:path], import_file[:original_filename])
    # (2..ss.last_row).each do |r|
      # row = ss.row(r)
    CSV.foreach(import_file[:path], { :headers => true, encoding: Encoding::SJIS }) do |row|
      next if row.all?(&:blank?) # すべて空白の列は無視

      ### マッチング処理 ###
      match_ids = if matchings.present?
        # マッチングするためのフィルタリング
        values = filter(matchings.map { |m| [ m[:table_header], row[m[:i]] ] }.to_h)

        if values.has_value? ""
          [] # マッチング条件の値がない(スキップする)
        else
          # AND条件マッチング
          if params[:option][:if] == "and" || params[:option][:if].blank?
            res = klass.where(values)
          end

          # OR条件マッチング
          if params[:option][:if] == "or" || (params[:option][:if].blank? && res.exists? && matchings.length > 1)
            cond = nil
            values.each do |k, v|
              cond = cond ? cond.or(ctd[k].eq(v)) : ctd[k].eq(v)
            end
            res = klass.where(cond)
          end

          res.limit(10).pluck(:id)
        end
      else
        []
      end

      ### マッチング結果 ###
      data = if match_ids.count == 1
        klass.find(match_ids.first)
      elsif match_ids.count == 0 && params[:option][:unmatch] == "new"
        klass.new
      else
        nil
      end

      ### 保存 ###
      if data.present?
        # begin
          params[:table_header].each do |i, h|
            next if params[:table_header][i].blank?

            # データ(バリデーション用に)格納
            if params[:method][i] == "update" \
               || (params[:method][i] == "save" && data[params[:table_header][i]].blank?) \
               || (params[:method][i] == "matching" && data.new_record? && params[:table_header][i] != "id")
              data[h] = row[i.to_i]
            end
          end

          data.save!
        # rescue ActiveRecord::RecordInvalid => e
        #
        # end
      end

      ### エラー出力処理 ###
      if data.blank?

      elsif data.errors.present?
        error = data.errors.messages.map do |k, v|
          v.map { |mes| "#{k} #{mes}" }.join("\n")
        end.join("\n")
      end


    #
    #     if data.errors.messages.present?
    #       title = :notvalid
    #       error = data.errors.messages.map do |k, v|
    #         v.map { |mes| "#{k} #{mes}" }.join("\n")
    #       end.join("\n")
    #     end
    #   end
    #
    #   session[:csv][:result][r] = [title, match_ids, error]
    end

    ActiveRecord::Base.connection.execute("VACUUM;")
  end

  private

  def create_client_table_before
    self[:table_name] ||=  "c_#{client_id}_#{Time.now.strftime('%Y%m%d%H%M%S')}"

    ActiveRecord::Base.connection.create_table(self[:table_name]) do |t|
      t.timestamps null: false
      t.datetime   :soft_destroyed_at
    end
  end

  def check_name(attributed)
    attributed[:name].blank? || attributed[:column_type].blank?
  end
end
