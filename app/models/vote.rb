class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :score, presence: true
  validates :votable_id, uniqueness: { scope: [:votable_type, :user_id] }
  validates :score , inclusion: { in: -1..1 }
end
