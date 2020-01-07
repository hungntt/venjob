class CitiesController < ApplicationController
  def index
    @countries_job_list = City.joins(:jobs).group(:region).count.sort_by(&:first)
  end

  def show
  end
end
