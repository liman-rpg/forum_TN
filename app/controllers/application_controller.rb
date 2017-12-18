require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  private

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { head :forbidden }
      format.json { head :forbidden }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def gon_user
    gon.user_sign_in = user_signed_in?
    gon.current_user_id = current_user.id if current_user
  end
end
