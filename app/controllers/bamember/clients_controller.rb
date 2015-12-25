class Bamember::ClientsController < Bamember::ApplicationController
  before_action :get_client, only: ["show", "edit", "update", "destroy", "edit_password", "update_password"]

  def show
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
  end

  def update
    if @client.update(client_params)
      redirect_to "/bamember/clients/#{params[:id]}/", notice: 'クライアント情報を変更しました'
    else
      render :edit
    end
  end

  def destroy
    @client.destroy!
    redirect_to "/bamember/clients/#{params[:id]}/", notice: 'クライアント情報を削除しました'
  end

  def edit_password
  end

  def update_password
    if @client.update(password_params)
      redirect_to "/bamember/clients/#{params[:id]}/", notice: 'クライアントのパスワードを変更しました'
    else
      render :edit_password
    end
  end

  private

  def get_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email, :password)
  end

  def password_params
    params.require(:client).permit(:password, :password_confirmation)
  end
end
