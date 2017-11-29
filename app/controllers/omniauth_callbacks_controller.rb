class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorization = User.find_or_create_authorization(request.env["omniauth.auth"])
    user = authorization.user

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    end
  end
end
