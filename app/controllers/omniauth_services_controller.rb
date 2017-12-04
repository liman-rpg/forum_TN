class OmniauthServicesController < ApplicationController
  def request_email
  end

  def save_email
    email = params[:email]
    if !email.blank?
      auth = { provider: session['devise.provider'], uid: session['devise.uid'], info: { email: email } }

      # transaction do
      authorization = User.find_or_create_authorization(auth)
      authorization.update!(status: false)
      # end

      OmniauthMailer.email_confirmation(authorization).deliver_now

      flash[:notice] = 'A message has been sent to your mail with a link to the confirmation mail.'
      redirect_to new_user_session_path
    else
      flash[:alert] = "Sorry. Something went wrong, try again."
      render request_email_path
    end
  end

  def confirm_email
    authorization = Authorization.find_by_confirm_token(params[:token])

    if authorization
      authorization.email_activate
      flash[:notice] = "Welcome to the Forum-TN! Your email has been confirmed.
      Please sign in to continue."
      redirect_to "/users/auth/#{authorization.provider}"
    else
      flash[:alert] = "Sorry. Something went wrong, try confirming the mail again."
      redirect_to new_user_session_path
    end
  end
end
