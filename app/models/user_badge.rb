class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :badge

  validates :awarded_at, presence: true
end
