class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relaciones
  has_many :challenges, foreign_key: :creator_id, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :joined_challenges, through: :participations, source: :challenge
  has_many :progress_entries, through: :participations
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges
  has_one :user_statistic, dependent: :destroy

  # Validaciones adicionales
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  # Métodos de rol
  def admin?
    role == "admin"
  end

  def creator?
    role == "creator"
  end

  def participant?
    role == "participant"
  end
end
