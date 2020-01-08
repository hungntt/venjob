class JobsController < ApplicationController
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
  end
end
