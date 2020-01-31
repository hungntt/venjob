class RequestsController < ApplicationController
  before_action :load_job, only: %i[new confirm done]
  before_action :new_request, only: %i[confirm done]
  before_action :check_input, only: %i[confirm done]

  def index
    @applied_job = current_user.requests
  end

  def new
    if params[:request].present?
      @request = @job.requests.new(request_params)
      @request.cv = @@temp.cv
    else
      @request = @job.requests.new
    end
  end

  def confirm
    @@temp = @request
    @@temp.store_cv!
  end

  def done
    @request.cv = @@temp.cv
    if @request.save!
      flash.now[:success] = "Successfully apply. Check mail confirmation at #{@request.email}"
      @request.send_confirmation_email
    else
      render :new
    end
  end

  private

  def load_job
    return redirect_back(fallback_location: root_path) if params[:job_id].nil?

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
