class JobsController < ApplicationController
  before_action :history, only: :show
  before_action :collection, only: :index

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
      binding.pry
      @name = "JOB LIST"
      jobs = Solr::Base.search(params)
      @job_count = jobs.count

      #params[:search_text] = "All job "
      #params[:search_text] += "have name/company name is #{params[:search]} " if params[:search].present?
      #params[:search_text] += "industry #{params[:industry]} " if params[:industry].present?
      #params[:search_text] += "in #{params[:city]} " if params[:city].present?
      #
      #@jobs = Job.all
    end
    @jobs = @jobs.order(updated_at: :desc).page(params[:page]).per(Settings.jobs.limit)
  end

  def show
    @job = Job.find(params[:id])
    return unless user_signed_in?

    @favorite_job = current_user.favorites.find_or_initialize_by(job_id: @job.id)
  end

  private

  def history
    return unless user_signed_in?

    history = current_user.histories.find_or_initialize_by(job_id: params[:id])
    history.update(updated_at: Time.current)
  end

  def collection
    @list_cities = City.all
    @list_industries = Industry.all
  end

end
