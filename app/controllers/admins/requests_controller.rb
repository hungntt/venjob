module Admins
  class RequestsController < BaseController
    def index
      @request = if params[:request].present?
                   @job.requests.new(request_params)
                 else
                   Request.all
                 end

    end
  end
end
