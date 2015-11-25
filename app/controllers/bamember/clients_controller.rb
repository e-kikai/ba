class Bamember::ClientsController < Bamember::ApplicationController
  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end
  

  def create
    Client.transaction do
      @client = Client.new(client_params)
      @client.save

      ClientTable.create_companies(@client.id)
      ClientTable.create_persons(@client.id)
      # ClientTable.create_actions(@client.id)
    end
    redirect_to "/bamember/", notice: '新規クライアントを登録しました'
  rescue => e
    flash.now[:alert] = "テーブル作成に失敗しました : #{e.message}"
    render :new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])

    if @client.update(client_params)
      redirect_to "/bamember/clients/#{params[:id]}/", notice: 'クライアント情報を変更しました'
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy!
    redirect_to "/bamember/clients/#{params[:id]}/", notice: 'クライアント情報を削除しました'
  end

  private

  def client_params
    params.require(:client).permit(:name, :email, :password)
  end
end
