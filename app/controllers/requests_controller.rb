class RequestsController < ApplicationController
  before_action :load_job, only: %i[new confirm done]
  before_action :new_request, only: %i[confirm done]
  before_action :check_input, only: %i[confirm done]

  def index
    @applied_job = current_user.requests
  end

  def done
    if @request.save
      flash.now[:success] = "Successfully apply. Check mail confirmation at #{@request.email}"
      @request.send_confirmation_email
    else
      render :new
    end
  end

  def new
    @request = if params[:request].present?
                 @job.requests.new(request_params)
               else
                 @job.requests.new
               end
  end

  def confirm
  end

  private

  def load_job
    @job = Job.find_by(id: params[:job_id])
  end

  def new_request
    @request = @job.requests.new(request_params)
  end

  def request_params
    params.require(:request).permit(:fname, :lname, :email, :cv)
  end

  def check_input
    unless @request.valid?
      flash[:danger] = "Missing requirements: " + @request.errors.full_messages.join(", ") + ". Please edit the form again."
      redirect_to new_job_request_path
    end
  end
end
