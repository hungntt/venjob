require 'open-uri'
require 'net/ftp'
require 'zip'
require 'csv'

namespace :job do
  desc "The crawler for City"

  task web_city_import: :environment do
    page = Nokogiri::HTML.parse(open('https://www.vnnic.vn/tenmien/hotro/danh-s%C3%A1ch-c%C3%A1c-t%E1%BB%89nh-th%C3%A0nh-v%C3%A0-th%C3%A0nh-ph%E1%BB%91?lang=en')); nil
    cities = page.at("table").text.gsub("\n\t\t\t", ",").gsub("\n", ",").partition("Các tỉnh,Thành phố,").last.split(",")
    city_list = []
    cities.each do |city|
      puts city
      city_list << City.new(name: city, region: "Vietnam")
    end
    city_list << City.new(name: "Bắc Cạn", region: "Vietnam")
    City.import city_list
    City.all.map(&:save!)
  end

  desc "This is the crawler from CareerBuilder"

  task web_job_import: :environment do
    page = Nokogiri::HTML.parse(open('https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html'))
    num_job = page.at("div[class='ais-stats'] h1[class='col-sm-10'] span").text.gsub(",", "").to_f
    num_pages = (num_job / 50).floor


    (1..num_pages).each do |num_page|
      page = Nokogiri::HTML.parse(open(URI.encode("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{num_page}-vi.html")))
      puts num_page
      (0..49).each do |k|
        job_url = page.xpath("//span[@class='jobtitle']/h3/a/@href")[k].text
        puts job_url
        job_page = Nokogiri::HTML.parse(open(URI.encode(job_url)))
        job_code = job_url.split('/').last.split('.')[-2]
        # Handle standard jobdetail page
        next unless job_page.at('body').values == ["jobseeker_site  jobdetail-standard"]

        #======Title========
        # Job name
        job_name = job_page.at("div[class='top-job-info'] h1").text.strip
        # Last update
        job_update = job_page.at("div[class='datepost'] span").text

        #======Info table=======
        info_table = job_page.xpath("//ul[@class='DetailJobNew']/li/p")
        job_workplace, job_salary, job_exp, job_position, job_deadline, job_industries = ''

        (0..info_table.count - 1).each do |info_part|
          info = info_table[info_part].text
          if info.include?("Nơi làm việc")
            job_workplace = info.gsub("/[\r\n]+/", "").partition(":").last.split(",")
          elsif info.include?("Lương")
            job_salary = info.gsub("/[\r\n]+/", "").partition(":").last.strip
          elsif info.include?("Kinh nghiệm")
            job_exp = info.gsub("/[\r\n]+/", "").partition(":").last.strip
          elsif info.include?("Cấp bậc")
            job_position = info.gsub("/[\r\n]+/", "").partition(":").last.strip
          elsif info.include?("Hết hạn nộp")
            job_deadline = info.gsub("/[\r\n]+/", "").partition(":").last.strip
          elsif info.include?("Ngành nghề")
            job_industries = info.gsub("/[\r\n]+/", "").partition(":").last.split(",")
          end
        end
        # ====Description=======
        job_desc, job_req = ''
        job_container_info = job_page.xpath("//div[@class='MarBot20']")
        (0..job_container_info.count - 1).each do |info_part|
          info = job_container_info[info_part].text
          if info.include?("Mô tả Công việc")
            job_desc = info.partition("Mô tả Công việc").last.strip
          elsif info.include?("Yêu Cầu Công Việc")
            job_req = info.partition("Yêu Cầu Công Việc").last.strip
          end
        end

        comp_name, comp_address = ""
        # Company full name
        unless job_page.at("div[class='tit_company']").nil?
          comp_name = job_page.at("div[class='tit_company']").text.strip
        end
        # Company address
        unless job_page.xpath("//p[@class='TitleDetailNew']/label")[0].nil?
          comp_address = job_page.xpath("//p[@class='TitleDetailNew']/label")[0].text.strip
        end
        # Company description
        comp_desc = job_page.xpath("//span[@id='emp_more']/p").text.strip

        job_workplace.each do |city_name|
          city_name = city_name.strip
          city_id = get_city_id(city_name)
          comp_id = get_comp_id(comp_name, city_id, comp_address, comp_desc)
          job_id = get_job_id(comp_id,
                              city_id,
                              job_name,
                              job_salary,
                              job_desc,
                              job_req,
                              job_position,
                              job_update,
                              job_deadline,
                              job_code,
                              job_exp)
          job_industries.each do |job_industry|
            industry_id = get_industry_id(job_industry.strip)
            IndustryJob.find_or_create_by!(industry_id: industry_id, job_id: job_id)
          end
        end
      end
    end
  end


  desc "CSV job crawler"

  task csv_import: :environment do
    Net::FTP.open("192.168.1.156", "training", "training")
    Zip::File.open("jobs.zip") do |zip_file|
      zip_file.each do |entry|
        entry.extract { true }
      end
    end
    CSV.foreach("jobs.csv", headers: true).with_index do |row, i|
      puts i
      job_industry = row["category"]
      comp_address = row["company address"]
      comp_name = row["company name"]
      job_position = row["level"]
      job_desc = row["description"]
      job_name = row["name"]
      job_req = row["requirement"]
      job_salary = row["salary"]
      job_workplace = row["work place"].strip

      city_id = get_city_id(job_workplace)
      comp_id = get_comp_id(comp_name, city_id, comp_address, nil)
      job_id = get_job_id(comp_id,
                          city_id,
                          job_name,
                          job_salary,
                          job_desc,
                          job_req,
                          job_position)

      industry_id = get_industry_id(job_industry)
      IndustryJob.find_or_create_by!(industry_id: industry_id, job_id: job_id)
    end
  end
end

def get_city_id(name)
  name = JSON.parse(name)[0] rescue name

  city = City.find_by(name: name)

  return city.id if city

  region = Geocoder.search(name).first.country
  puts name, region
  City.create!(name: name, region: region).id rescue City.find_by(slug: name.to_url).id
end

def get_comp_id(comp_name, city_id, comp_address, comp_desc = nil)
  company = Company.find_or_initialize_by(name: comp_name, city_id: city_id)
  company.update(address: comp_address, description: comp_desc)
  company.id
end

def get_job_id(company_id, city_id, job_name, job_salary, job_desc, job_req, job_position, job_update = nil, job_deadline = nil, job_code = nil, job_exp = nil)
  if job_deadline.nil?
    job = Job.find_or_initialize_by(name: job_name, company_id: company_id, city_id: city_id)
  else
    job = Job.find_or_initialize_by(code: job_code)
  end

  job.update(code: job_code,
             name: job_name,
             company_id: company_id,
             city_id: city_id,
             salary: job_salary,
             deadline: job_deadline,
             description: job_desc,
             requirement: job_req,
             last_updated: job_update,
             position: job_position,
             experience: job_exp)
  job.id
end

def get_industry_id(name)
  industry = Industry.find_or_create_by!(name: name) rescue Industry.find_by(slug: name.to_url)
  industry.id
end
