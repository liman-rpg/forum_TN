class Question < ApplicationRecord
  include Attachable
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :body, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
