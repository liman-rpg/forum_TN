class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true

  def email_activate
    self.update!(email_confirmed: true, confirm_token: nil)
  end

  def status_activate
    self.update!(status: true)
  end

  def self.find_or_create_authorization(auth)
    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid].to_s).first
    return authorization if authorization

    email = auth[:info][:email]
    return nil if email.nil?

    user = User.where(email: email).first

    if !user
      name     = (auth[:info][:name] || 'User')
      password = Devise.friendly_token[0, 20]
      user     = User.create!(name: name, email: email, password: password, password_confirmation: password)
    end

    user.create_authorization(auth)
  end
end
