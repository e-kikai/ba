class ImportJob < ActiveJob::Base
  queue_as :ba

  # ファイルインポートのバックグラウンドジョブ
  #
  # @param [integer] table_id  登録する顧客テーブルID
  # @param [integer] import_id インポート情報ID
  def perform(import_id)
    Import.find(import_id).import
  end
end
