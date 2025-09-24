class Exercise < ApplicationRecord
  has_many :progress_entries, dependent: :destroy

  validates :name, :category, :unit, presence: true
end
