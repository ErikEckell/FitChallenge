# app/controllers/participations_controller.rb
class ParticipationsController < ApplicationController
  def index
    @participations = Participation.all
  end

  def show
    @participation = Participation.find(params[:id])
  end
end
