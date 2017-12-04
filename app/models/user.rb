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

  def create_authorization(auth)
    token = Devise.friendly_token[0, 20]
    self.authorizations.create!(provider: auth[:provider], uid: auth[:uid], status: true, confirm_token: token)
  end
end
