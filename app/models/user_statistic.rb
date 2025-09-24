class UserStatistic < ApplicationRecord
  belongs_to :user

  validates :total_points, :total_distance, :total_reps, :total_minutes,
            :completed_challenges,
            numericality: { greater_than_or_equal_to: 0 }
end
