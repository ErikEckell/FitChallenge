class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge, only: [:show, :edit, :update, :destroy, :join]
  before_action :authorize_creator_or_admin!, only: [:edit, :update, :destroy, :new, :create]

  def index
    @challenges = Challenge.all
  end

  def show
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = current_user.challenges.build(challenge_params)
    if @challenge.save
      redirect_to @challenge, notice: "Challenge created successfully!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @challenge.update(challenge_params)
      redirect_to @challenge, notice: "Challenge updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @challenge.destroy
    redirect_to challenges_path, notice: "Challenge deleted."
  end

  # Participante se une al challenge
  def join
    if current_user.role == "participant" && !@challenge.participants.include?(current_user)
      Participation.create!(user: current_user, challenge: @challenge, joined_at: DateTime.now, total_points: 0, status: "active")
      redirect_to @challenge, notice: "You joined the challenge!"
    else
      redirect_to @challenge, alert: "You cannot join this challenge."
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:title, :description, :start_date, :end_date)
  end

  def authorize_creator_or_admin!
    if action_name.in?(%w[new create])
      redirect_to challenges_path, alert: "You are not authorized." unless current_user.admin? || current_user.creator?
    else
      redirect_to challenges_path, alert: "You are not authorized." unless current_user.admin? || @challenge.creator == current_user
    end
  end

end
