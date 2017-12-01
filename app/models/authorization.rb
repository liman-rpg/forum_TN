class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true

  def email_activate
    self.update!(email_confirmed: true, confirm_token: nil)
  end

  def status_activate
    self.update!(status: true)
  end
end
