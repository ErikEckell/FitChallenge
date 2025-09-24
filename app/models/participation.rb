class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  has_many :progress_entries, dependent: :destroy

  validates :user_id, uniqueness: { scope: :challenge_id }
end
