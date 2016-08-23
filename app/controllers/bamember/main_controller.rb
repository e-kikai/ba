require "open3"

class Bamember::MainController < Bamember::ApplicationController
  def index
    @clients = Client.all.order :created_at
  end

  # Unicornの手動再起動
  def unicorn_restart
    if Rails.env.development?
      Open3.popen3('sleep 3; sudo systemctl restart unicorn_ba')
    else
      Open3.popen3('sleep 3; sudo /etc/init.d/unicorn_ba restart')
    end

    redirect_to "/bamember/", notice: "Unicorn再起動を実行しました。再起動完了までしばらくお待ち下さい"
  end

  def sidekiq_restart
    if Rails.env.development?
      `sudo systemctl restart sidekiq_ba`
    else
      `sudo /etc/init.d/sidekiq_ba restart`
    end

    redirect_to "/bamember/", notice: "Sidekiq再起動を実行しました。再起動完了までしばらくお待ち下さい"
  end
end
