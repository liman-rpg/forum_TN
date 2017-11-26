class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?

    # Не пойму как это проверить и соответсвенно путанница с пониманием кода. (Код взят из офф источника)
    # else
    # redirect_to new_user_registration_url
    end
  end
end
