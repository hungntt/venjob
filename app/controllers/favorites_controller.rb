class FavoritesController < ApplicationController
  before_action :load_job, only: %i[create destroy]
  before_action :new_fav_job, only: %i[create]
  before_action :load_favorite_job, only: :destroy
  before_action :load_user, only: :index

  def index
    @jobs = current_user.favorites
  end

  def create
    if @fav_job.save
      flash.now[:success] = "Successfully add new job"
    else
      flash.now[:danger] = "not successful"
    end
  end

  def destroy
    if @favorited_job.destroy
      flash.now[:success] = "Successfully delete favorite job"
    else
      flash.now[:danger] = "not successful"
    end
  end

  private

  def load_job
    @job = Job.find_by(id: params[:job_id])
  end

  def load_user
    @user = User.find_by(id: current_user.id)
  end

  def new_fav_job
    @fav_job = @job.favorites.new(saved_job_params)
  end

  def load_favorite_job
    @favorited_job = SavedJob.find_by(favorited_job_params)
  end

  def saved_job_params
    params.permit(:user_id, :job_id, :role)
  end

  def favorited_job_params
    params.permit(:id)
  end
end
