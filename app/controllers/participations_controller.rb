class ParticipationsController < ApplicationController
  before_action :set_participation, only: [:show, :edit, :update, :destroy]

  def index
    @participations = Participation.all
  end

  def show
  end

  def new
    @participation = Participation.new
  end

  def create
    @participation = Participation.new(participation_params)
    if @participation.save
      redirect_to @participation, notice: "Participation successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @participation.update(participation_params)
      redirect_to @participation, notice: "Participation successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @participation.destroy
    redirect_to participations_path, notice: "Participation successfully deleted."
  end

  private

  def set_participation
    @participation = Participation.find(params[:id])
  end

  def participation_params
    params.require(:participation).permit(:user_id, :challenge_id, :joined_at, :total_points, :status)
  end
end
