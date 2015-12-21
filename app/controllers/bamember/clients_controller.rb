class Bamember::ClientsController < Bamember::ApplicationController
  def show
    @client = Client.find(params[:id])
  end

  def new
    @clients = Client.all.order :created_at

    @client      = Client.new
    @template_id = nil
  end

  def create
    Client.transaction do
      @template_id = params[:template_id]

      @client = Client.new(client_params)
      @client.save

      if @template_id.present?
        ClientTable.clone_tables(@client.id, @template_id)
      else
        ClientTable.init_tables(@client.id)
      end

    end
    redirect_to "/bamember/", notice: '新規クライアントを登録しました'
  rescue => e
    @clients = Client.all.order :created_at
    flash[:alert] = e.message
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
