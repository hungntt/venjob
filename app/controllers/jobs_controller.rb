class JobsController < ApplicationController
  before_action :history, only: :show
  before_action :collection, only: :index

  def index
    if params[:city_id].present?
      city = City.friendly.find(params[:city_id])
      @name = city.name
      @jobs = city.jobs
      @jobs = Kaminari.paginate_array(@jobs.order(updated_at: :desc)).page(params[:page]).per(Settings.jobs.limit)
    elsif params[:industry_id].present?
      job = Industry.friendly.find(params[:industry_id])
      @name = job.name
      @jobs = job.jobs
      @jobs = Kaminari.paginate_array(@jobs.order(updated_at: :desc)).page(params[:page]).per(Settings.jobs.limit)
    else
      @name = "Find: " + params[:search]
      @name += " at " + params[:city] unless params[:city].empty?
      @name += " in " + params[:industry] unless params[:industry].empty?

      @jobs = Solr::Base.search(params)
      @jobs = Kaminari.paginate_array(@jobs).page(params[:page]).per(Settings.jobs.limit)
    end

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
