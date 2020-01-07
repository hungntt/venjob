class JobsController < ApplicationController
  def index
    @jobs = Job.all.order(updated_at: :desc).paginate(page: params[:page], per_page: 50)
  end

  def show
  end
end
