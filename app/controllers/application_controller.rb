class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:fname, :lname, :password, :current_password)}
  end
end
