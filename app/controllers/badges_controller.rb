class BadgesController < ApplicationController
  before_action :set_badge, only: [:show, :edit, :update, :destroy]

  def index
    @badges = Badge.all
  end

  def show
    @badge = Badge.find(params[:id])
    authorize! :read, @badge
  end

  def new
    @badge = Badge.new
  end

  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      redirect_to @badge, notice: "Badge successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @badge = Badge.find(params[:id])
    authorize! :update, @badge
  end

  def update
    if @badge.update(badge_params)
      redirect_to @badge, notice: "Badge successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @badge = Badge.find(params[:id])
    authorize! :destroy, @badge
    @badge.destroy
    redirect_to badges_path, notice: "Badge deleted"
  end


  private

  def set_badge
    @badge = Badge.find(params[:id])
  end

  def badge_params
    params.require(:badge).permit(:name, :description, :condition)
  end
end
