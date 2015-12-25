class ClientController < ApplicationController
  def index
  end

  def edit_password
  end

  def update_password
    if @client.update_with_password(password_params)
      redirect_to "/", notice: 'パスワードを変更しましたので、再度ログインしてください'
    else
      render :edit_password
    end
  end

  private

  def password_params
    params.require(:client).permit(:password, :password_confirmation, :current_password)
  end
end
