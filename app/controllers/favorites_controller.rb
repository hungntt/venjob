class FavoritesController < ApplicationController
  before_action :load_job, only: %i[create destroy]
  before_action :set_favorite_job, only: %i[create]
  before_action :load_favorite_job, only: :destroy
  before_action :load_user, only: :index

  def index
    @jobs = @user.favorites
  end

  def create
    if @favorite_job.save!
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
    @user = current_user
  end

  def set_favorite_job
    @favorite_job = current_user.favorites.new(favorite_job_params)
  end

  def load_favorite_job
    @favorited_job = current_user.favorites.find(params[:id])
  end

  def favorite_job_params
    params.permit(:user_id, :job_id)
  end
end
