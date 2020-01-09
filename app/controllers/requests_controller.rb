class RequestsController < ApplicationController
  before_action :load_job, only: %i[new confirm]
  before_action :new_request, only: %i[confirm done]
  before_action :check_input, only: %i[confirm done]
  after_action :set_request_job_id, only: %i[new]

  def index
  end


  def create
  end

  def done
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
    @request = if params[:request].present?
                 Request.new(request_params)
               else
                 Request.new
               end

  end

  def confirm

  end

  private

  def new_request
    @request = Request.new(request_params)
    set_request_job_id
  end

  def load_job
    @job = Job.find_by(id: params[:job_id])
  end

  def request_params
    params.require(:request).permit(:fname, :lname, :email, :cv)
  end

  def set_request_job_id
    @request.job_id = params[:job_id]
  end

  def check_input
    unless @request.valid?
      flash[:danger] = "Missing requirements: " + @request.errors.full_messages.join(", ") + ". Please click 'Edit' to fill the form again."
      redirect_to new_job_request_path
    end
  end
end
