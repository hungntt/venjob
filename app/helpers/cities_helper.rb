module CitiesHelper
  def countries_job_list(country_name)
    City.joins(:jobs).where(region: country_name).group(:name).count.sort_by(&:first)
  end
end
