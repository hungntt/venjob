class PagesController < ApplicationController
  def home
    @latest_jobs = Job.order(updated_at: :desc).limit(Settings.home_page.job_list_limit)

    @top_cities = City.all.map { |c| [c, c.jobs.count] }.sort_by(&:second).reverse.take(Settings.home_page.city_list_limit)

    @top_industries = Industry.all.map { |i| [i, i.industry_jobs.count] }.sort_by(&:second).reverse.take(Settings.home_page.industry_list_limit)

  end

  def search
  end
end
