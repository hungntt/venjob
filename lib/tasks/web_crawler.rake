require 'open-uri'

namespace :web_crawler do
  desc "This is the crawler from CareerBuilder"

  task :web_crawl_data do
    page = Nokogiri::HTML.parse(open('https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html')); nil
    num_job = page.at("div[class='ais-stats'] h1[class='col-sm-10'] span").text.gsub(",", "").to_f
    num_pages = (num_job / 50).floor

    (1..num_pages).each do |num_page|
      page = Nokogiri::HTML.parse(open(URI.encode("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{num_page}-vi.html")))
      (1..50).each do |k|
        job_url = page.at("dd[class='brief bold-red'][#{k}] h3[class='job'] a")['href']
        job_page = Nokogiri::HTML.parse(open(URI.encode(job_url)))
        job_code = job_url.split('/').last.split('.')[-2]
        # Handle standard jobdetail page
        if job_page.at('body').values == ["jobseeker_site  jobdetail-standard"]
          #======Title========
          # Job name
          job_name = job_page.at("div[class='top-job-info'] h1").text
          # Company full name
          comp_name = job_page.at("div[class='tit_company']").text
          # Last update
          job_update = job_page.at("div[class='datepost'] span").text

          #======Info table=======
          info_table = job_page.xpath("//ul[@class='DetailJobNew']/li/p")
          job_workspace, job_salary, job_exp, job_position, job_deadline, job_industry = String.new

          (0..info_table.count - 1).each do |info_part|
            info = info_table[info_part].text
            if info.include?("Nơi làm việc")
              job_workplace = info.gsub("/[\r\n]+/", "").partition(":").last.strip
            elsif info.include?("Lương")
              job_salary = info.gsub("/[\r\n]+/", "").partition(":").last.strip
            elsif info.include?("Kinh nghiệm")
              job_exp = info.gsub("/[\r\n]+/", "").partition(":").last.strip
            elsif info.include?("Cấp bậc")
              job_position = info.gsub("/[\r\n]+/", "").partition(":").last.strip
            elsif info.include?("Hết hạn nộp")
              job_deadline = info.gsub("/[\r\n]+/", "").partition(":").last.strip
            elsif info.include?("Ngành nghề")
              job_industry = info.gsub("/[\r\n]+/", "").partition(":").last.strip.split(", ")
            end
          end
          # Description
          job_desc = job_page.xpath("//div[@class='MarBot20']").text.gsub("\r\b", "").strip
          Job.create(code: job_code,
                     name: job_name,
                     salary: job_salary,
                     deadline: job_deadline,
                     description: job_desc,
                     last_updated: job_update,
                     position: job_position,
                     experience: job_exp,)


          # Company address
          address = job_page.xpath("//p[@class='TitleDetailNew']/label")[0].text.strip
          # Company description
          comp_description = job_page.xpath("//span[@id='emp_more']/p").text
        end
      end
    end
  end
end
