class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, flash: { error: exception.message }
  end

  before_action :authenticate_user!
  helper_method :disable_header

  protected

  def disable_header
    @disable_header = true
  end
end
