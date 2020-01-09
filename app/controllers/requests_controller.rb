class RequestsController < ApplicationController
  before_action :load_job, only: %i[new confirm]

  def index
  end


  def create
  end

  def done
    @request = Request.new(request_params)
    @request.job_id = params[:job_id]
    if @request.save
      flash.now[:success] = "Successfully apply. Check mail confirmation at #{@request.email}"
      @request.send_confirmation_email
    else
      render :new
    end
  end

  def show
  end

  def new
    @request = Request.new(request_params) rescue Request.new
  end

  def confirm
    @request = Request.new(request_params)
  end

  private

  def load_job
    @job = Job.find_by(id: params[:job_id])
  end

  def request_params
    params.require(:request).permit(:fname, :lname, :email, :cv)
  end
end
