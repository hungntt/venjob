module AdminsHelper
  def cities_list
    City.all.select { |c| c.job_count.positive? }
  end

  def industries_list
    Industry.all
  end
end
