class Bamember::ClientsController < Bamember::ApplicationController
  before_action :get_client, only: ["show", "edit", "update", "destroy", "edit_password", "update_password", :bi, :bi_update]

  def show
  end

  def bi
  end

  def bi_update
    if @client.update(bi_params)
      redirect_to "/bamember/clients/#{@client.id}/", notice: "ダッシュボードを変更しました"
    else
      render :bi
    end
  end

  def new
    @clients = Client.all.order :created_at
    @client  = Client.new
  end

  def create
    Client.transaction do
      @client = Client.new(client_params)
      @client.save

      if params[:template_id].present?
        ClientTable.clone_tables(@client.id, params[:template_id])
      else
        ClientTable.create_company_table(@client.id)
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
      redirect_to "/bamember/clients/#{params[:id]}/", notice: "#{@client.name}を変更しました"
    else
      render :edit
    end
  end

  def destroy
    @client.soft_destroy!
    redirect_to "/bamember/", notice: "#{@client.name}を削除しました"
  end

  def edit_password
  end

  def update_password
    if @client.update(password_params)
      redirect_to "/bamember/clients/#{params[:id]}/", notice: "#{@client.name}のパスワードを変更しました"
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

  def bi_params
    params.require(:client).permit(dashboards_attributes: [:id, :name, :url, :size, :order_no, :_destroy])
  end
end
