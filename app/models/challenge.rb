# app/models/challenge.rb
class Challenge < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_many :progress_entries, through: :participations

  validates :title, :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be before the start date")
    end
  end
end
