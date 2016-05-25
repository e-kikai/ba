class Bamember::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_bamember!

  layout 'layouts/application'

  rescue_from RuntimeError, with: :runtime_error

  private

  # def runtime_error(e = nil)
  #   logger.error e
  #   logger.error e.backtrace.join("\n")
  #   redirect_to "/bamember/", alert: e.message
  # end
end
