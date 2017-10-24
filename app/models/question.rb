class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates :body, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments
end
