class IndustriesController < ApplicationController
  def index
    @industries_job_list = Industry.joins(:industry_jobs).group(:name).count.sort_by(&:first)
  end

  def show
  end
end
