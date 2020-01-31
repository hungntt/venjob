module Admins
  class RequestsController < BaseController
    def index
      params[:q] ||= {}
      if params[:q][:created_at_lteq].present?
        params[:q][:created_at_lteq] = params[:q][:created_at_lteq].to_date.end_of_day
      end
      @query = Request.ransack(params[:q])
      @request = @query.result(distinct: true).page(params[:page]).per(Settings.jobs.limit)

      respond_to do |format|
        format.html
        format.csv { send_data Request.to_csv(@request), filename: "data-#{Time.current.strftime("%d%m%Y%H%M")}.csv" }
      end
    end
  end
end
