module Admins
  class RequestsController < BaseController
    def index
      @query = Request.ransack(params[:q])
      @request = @query.result(distinct: true)
    end
  end
end
