class JobsController < ApplicationController
  before_action :history, only: :show

  def index
    if params[:city_id].present?
      city = City.friendly.find(params[:city_id])
      @name = city.name
      @jobs = city.jobs
    elsif params[:industry_id].present?
      job = Industry.friendly.find(params[:industry_id])
      @name = job.name
      @jobs = job.jobs
    else
      @name = "JOB LIST"
      @jobs = Job.all
    end
    @jobs = @jobs.order(updated_at: :desc).page(params[:page]).per(Settings.jobs.limit)
  end

  def show
    @job = Job.find(params[:id])
    @favorite_job = @job.favorites.new(user_id: current_user.id)
    @favorited_job = current_user.favorites.find_by(job_id: @job.id)

  end

  private

  def history
    return unless user_signed_in?

    history = current_user.histories.find_or_initialize_by(job_id: params[:id])
    history.update(updated_at: Time.current)
  end
end
