class Challenge < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_many :progress_entries, through: :participations

  validates :title, :start_date, :end_date, presence: true
end
