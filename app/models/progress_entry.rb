class ProgressEntry < ApplicationRecord
  belongs_to :participation
  belongs_to :exercise

  validates :entry_date, presence: true
  validates :metric_value, numericality: { greater_than_or_equal_to: 0 }

  validate :entry_date_within_challenge_range

  private

  def entry_date_within_challenge_range
    return unless participation && participation.challenge

    challenge = participation.challenge
    if entry_date.present? && (entry_date < challenge.start_date || entry_date > challenge.end_date)
      errors.add(:entry_date, "must be within the challenge duration (#{challenge.start_date} to #{challenge.end_date})")
    end
  end
end
