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

    def check_and_award_badges
    Badge.all.each do |badge|
      next if user_badges.exists?(badge: badge) # ya lo tiene
      if meets_badge_condition?(badge)
        UserBadge.create!(user: self, badge: badge, awarded_at: Time.current)
      end
    end
  end
  
  def update_statistics!
    stats = user_statistic || build_user_statistic
    stats.total_points = participations.joins(:progress_entries).sum("progress_entries.points")
    stats.total_distance = participations.joins(progress_entries: :exercise).where("exercises.unit = ?", "km").sum("progress_entries.metric_value")
    stats.total_reps = participations.joins(progress_entries: :exercise).where("exercises.unit = ?", "reps").sum("progress_entries.metric_value")
    stats.total_minutes = participations.joins(progress_entries: :exercise).where("exercises.unit = ?", "minutes").sum("progress_entries.metric_value")
    stats.completed_challenges = participations.where(status: "completed").count
    stats.last_update = Time.current
    stats.save!
  end

  private

  def meets_badge_condition?(badge)
    stats = self.user_statistic
    return false unless stats

    case badge.condition
    when /total_distance >= (\d+) km/
      stats.total_distance >= $1.to_f
    when /total_reps >= (\d+)/
      stats.total_reps >= $1.to_i
    when /total_minutes >= (\d+)/
      stats.total_minutes >= $1.to_i
    when /total_points >= (\d+)/
      stats.total_points >= $1.to_i
    else
      false
    end
  end

end
