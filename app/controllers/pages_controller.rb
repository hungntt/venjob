class PagesController < ApplicationController
  def home
    @latest_jobs = Job.order(updated_at: :desc).limit(5)

    @top_cities = City.all.map { |c| [c, c.jobs.count] }.sort_by(&:second).reverse.take(11)

    @top_industries = Industry.all.map { |i| [i, i.industry_jobs.count] }.sort_by(&:second).reverse.take(11)
  end

  def search
  end
end
