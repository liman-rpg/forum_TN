class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  validates :name, presence: true

  def author_of?(object)
    id == object.user_id
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

  def create_authorization(auth)
    token = Devise.friendly_token[0, 20]
    self.authorizations.create!(provider: auth[:provider], uid: auth[:uid], status: true, confirm_token: token)
  end
end
