class ClientTableData < ActiveRecord::Base
  soft_deletable
  default_scope { without_soft_destroyed }

  #フィルタ・デフォルト値
  before_validation do |data|
    client_table = self.class.get_client_table

    client_table.client_columns.each do |co|
      if co.db_column_type[:filter].present?
        data[co.column_name] = co.db_column_type[:filter].call(data[co.column_name])
      end

      if co[:default].present?
        data[co.column_name] = co[:default] if new_record? && data[co.column_name].blank?
      end
    end
  end

  # 手動バリデータ
  validate do |data|
    client_table = self.class.get_client_table

    client_table.client_columns.each do |co|
      # 必須チェック
      if co[:presence].present?
        errors.add(co.name, "(#{co.db_column_type[:name]}型)必須") if data[co.column_name].blank?
      end

      # ユニーク(空白とデフォルト値は除外)
      if co[:unique].present? && data[co.column_name].present? && data[co.column_name] != co[:default]
        if self.class.where(co.column_name => data[co.column_name]).where.not(id: data[:id]).exists?
          errors.add(co.name, "(#{co.db_column_type[:name]}型)重複")
        end
      end

      # 型バリデーション
      if co.db_column_type[:valid].present? && data[co.column_name].present?
        unless co.db_column_type[:valid].call(data[co.column_name])
          errors.add(co.name, "(#{co.db_column_type[:name]}型)不正な値")
        end
      end
    end
  end

  def self.get_client_table
    ClientTable.find_by(table_name: self.table_name)
  end

  def self.get_klass(client_table_name)
    self.table_name = client_table_name
    reset_column_information
    self
  end
end
