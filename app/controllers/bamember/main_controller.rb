class Bamember::MainController < Bamember::ApplicationController
  def index
    @clients = Client.all.order :created_at
  end
end
