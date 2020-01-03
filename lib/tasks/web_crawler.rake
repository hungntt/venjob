require 'open-uri'
require 'net/ftp'
require 'zip'
require 'csv'

namespace :web_city_crawler do
  desc "The crawler for City"

  task :web_city_crawl => :environment do
    page = Nokogiri::HTML.parse(open('https://www.vnnic.vn/tenmien/hotro/danh-s%C3%A1ch-c%C3%A1c-t%E1%BB%89nh-th%C3%A0nh-v%C3%A0-th%C3%A0nh-ph%E1%BB%91?lang=en')); nil
    cities = page.at("table").text.gsub("\n\t\t\t", ",").gsub("\n", ",").partition("Các tỉnh,Thành phố,").last.split(",")
    cities.each_with_index do |city, index|
      if index == cities.size - 1
        City.create!(name: "Hồ Chí Minh", region: "Việt Nam")
      else
        City.create!(name: city, region: "Việt Nam")
      end
    end

  end
end

namespace :web_job_crawler do
  desc "This is the crawler from CareerBuilder"

  task :web_job_crawl => :environment do
    page = Nokogiri::HTML.parse(open('https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html')); nil
    num_job = page.at("div[class='ais-stats'] h1[class='col-sm-10'] span").text.gsub(",", "").to_f
    num_pages = (num_job / 50).floor

    (1..num_pages).each do |num_page|
      page = Nokogiri::HTML.parse(open(URI.encode("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{num_page}-vi.html"))); nil
      puts num_page
      (0..49).each do |k|
        job_url = page.xpath("//span[@class='jobtitle']/h3/a/@href")[k].text
        puts job_url
        job_page = Nokogiri::HTML.parse(open(URI.encode(job_url))); nil
        job_code = job_url.split('/').last.split('.')[-2]
        # Handle standard jobdetail page
        next unless job_page.at('body').values == ["jobseeker_site  jobdetail-standard"]

        #======Title========
        # Job name
        job_name = job_page.at("div[class='top-job-info'] h1").text
        # Last update
        job_update = job_page.at("div[class='datepost'] span").text

        #======Info table=======
        info_table = job_page.xpath("//ul[@class='DetailJobNew']/li/p")
        job_workplace, job_salary, job_exp, job_position, job_deadline, job_industries = ''

        (0..info_table.count - 1).each do |info_part|
          info = info_table[info_part].text
          if info.include?("Nơi làm việc")
            job_workplace = get_city_id(City.find_by(name: info.gsub("/[\r\n]+/", "").partition(":").last.strip))
          elsif info.include?("Lương")
            job_salary = info.gsub("/[\r\n]+/", "").partition(":").last.strip
          elsif info.include?("Kinh nghiệm")
            job_exp = info.gsub("/[\r\n]+/", "").partition(":").last.strip
          elsif info.include?("Cấp bậc")
            job_position = info.gsub("/[\r\n]+/", "").partition(":").last.strip
          elsif info.include?("Hết hạn nộp")
            job_deadline = info.gsub("/[\r\n]+/", "").partition(":").last.strip
          elsif info.include?("Ngành nghề")
            job_industries = info.gsub("/[\r\n]+/", "").partition(":").last.strip.split(", ")
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

        comp_address, comp_desc = ''
        # Company full name
        comp_name = job_page.at("div[class='tit_company']").text
        if Company.exists?(name: comp_name)
          comp_id = Company.find_by(name: comp_name).id
        else
          # Company address
          comp_address = job_page.xpath("//p[@class='TitleDetailNew']/label")[0].text.strip
          # Company description
          comp_desc = job_page.xpath("//span[@id='emp_more']/p").text
          create_company(comp_name, comp_address, comp_desc)
          comp_id = Company.last.id
        end
        create_company(comp_name, comp_address, comp_desc)

        Job.create!([code: job_code,
                     name: job_name,
                     salary: job_salary,
                     deadline: job_deadline,
                     description: job_desc,
                     requirement: job_req,
                     last_updated: job_update,
                     position: job_position,
                     experience: job_exp,
                     city_id: job_workplace,
                     company_id: comp_id])

        job_id = Job.last.id

        (0..job_industries.count).each do |job_industry|
          Industry.create!(name: job_industry) unless Industry.exists?(name: job_industry)

          industry_id = Industry.find_by(name: job_industry).id
          IndustryJob.create!(industry_id: industry_id, job_id: job_id)
        end
      end
    end
  end
end

namespace :csv_job_crawler do
  desc "CSV job crawler"

  task :csv_job_crawl => :environment do
    Net::FTP.open('192.168.1.156', 'training', 'training')
    Zip::File.open("jobs.zip")
    table = CSV.parse(File.read("jobs.csv"), headers: true)
    num_row = table.count - 2
    puts num_row
    (0..num_row).each do |row|
      puts row
      job_industry = table[row][1]
      comp_address = table[row][2]
      comp_name = table[row][5]
      job_position = table[row][8]
      job_desc = table[row][7]
      job_name = table[row][9]
      job_req = table[row][10]
      job_salary = table[row][11]

      job_workplace = get_city_id(table[row][16])

      if Company.exists?(name: comp_name)
        comp_id = Company.find_by(name: comp_name).id
      else
        create_company(comp_name, comp_address)
        comp_id = Company.last.id
      end

      Job.create!([name: job_name,
                   salary: job_salary,
                   description: job_desc,
                   requirement: job_req,
                   position: job_position,
                   city_id: job_workplace,
                   company_id: comp_id])

      job_id = Job.last.id

      Industry.create!(name: job_industry) unless Industry.exists?(name: job_industry)

      industry_id = Industry.find_by(name: job_industry).id
      IndustryJob.create!(industry_id: industry_id, job_id: job_id)
    end
  end
end

def create_company(comp_name, comp_address, comp_desc = nil)
  Company.create!([name: comp_name,
                   address: comp_address,
                   description: comp_desc])
end

def get_city_id(name, region = "Việt Nam")
  if City.exists?(name: name)
    City.find_by(name: name).id
  else
    begin
      name = JSON.parse(name)[0]
      if name
        if City.exists?(name: name)
          City.find_by(name: name).id
        else
          City.create(name: name, region: region)
          City.last.id
        end
      end
    rescue ParseError
      City.create(name: name, region: region)
      City.last.id
    end
  end
end
