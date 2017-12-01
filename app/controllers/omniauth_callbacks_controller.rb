class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorize
  end

  def twitter
    authorize
  end

  private

  def authorize
    auth = request.env["omniauth.auth"]
    authorization = User.find_or_create_authorization(auth)
    user = authorization.user if authorization

    if authorization.nil?
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to request_email_path
    elsif !authorization.status && !authorization.email_confirmed
      flash[:alert] = 'You need to confirm your email. Check your mailbox'
      redirect_to new_user_registration_path
    elsif user.persisted?
      if !authorization.status && authorization.email_confirmed
        user.update!(name: auth[:info][:name] )
        authorization.status_activate
      end

      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: authorization.provider.capitalize) if is_navigational_format?
    end
  end
end
