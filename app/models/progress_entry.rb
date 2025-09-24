class ProgressEntry < ApplicationRecord
  belongs_to :participation
  belongs_to :exercise

  validates :entry_date, presence: true
  validates :metric_value, numericality: { greater_than_or_equal_to: 0 }
end
