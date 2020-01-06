class CitiesController < ApplicationController
  def index
    @countries_job_list = City.joins(:jobs).group(:region).count.sort_by(&:second).reverse
  end

  def show
  end
end
