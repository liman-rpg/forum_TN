class OmniauthMailer < ApplicationMailer
  def email_confirmation(authorization)
    @url = "#{confirm_email_url}?token=#{authorization.confirm_token}"
    mail(to: authorization.user.email, subject: "Email Confirmation")
 end
end
