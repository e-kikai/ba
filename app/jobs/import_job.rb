class ImportJob < ActiveJob::Base
  queue_as :ba

  # ファイルインポートのバックグラウンドジョブ
  #
  # @param [integer] id     登録する顧客テーブルID
  # @param [Hash]    params      パラメータ
  # @param [Hash]    import_file インポートファイルパス
  def perform(id, params, import_file)
    ClientTable.find(id).import(params, import_file)
  end

  # around_perfome do |job|
  # end


end
