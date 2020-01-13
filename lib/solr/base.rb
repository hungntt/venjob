require "rsolr"
require "rsolr-ext"
require "kconv"

module Solr
  class Base < Rails::Application
    def self.solr_connection
      @solr_connection ||= RSolr::Ext.connect(url: Settings.solr.object_core.url,
                                              update_format: :json,
                                              open_timeout: Settings.solr.connection.open_timeout,
                                              read_timeout: Settings.solr.connection.read_timeout,
                                              retry_503: Settings.solr.connection.retry_503)
    end

    def self.add_data(job)
      solr_connection.add id: job.id, title: job.name, company: job.company_name, industry: job.industries.pluck(:name), city: job.city_name, salary: job.salary
      solr_connection.commit
    end

    def self.delete_data(id)
      solr_connection.delete_by_id id
      solr_connection.commit
    end

    def self.search(keyword)
      #if type.include?("city") || type.include?("industry")
      #  response = solr_connection.select params: { q: "#{type}:\"#{escape(keyword)}\"", rows: Job.count }
      #else
      keyword[:search] ||= ""
      industry = keyword[:industry].present? ? "industry:\"#{escape(keyword[:industry])}\"" : "industry:*"
      city = keyword[:city].present? ? "city:\"#{escape(keyword[:city])}\"" : "city:*"
      response = solr_connection.select params: {q: "search_str:*#{escape(keyword[:search])}*", fq: [industry, city], rows: Job.count}
      #end

      response["response"]["docs"]

    end

    def self.escape(str)
      # note that the gsub will parse the escaped backslashes, as will the ruby code sending the query to Solr
      # so the result sent to Solr is ultimately a single backslash in front of the particular character
      RSolr.solr_escape(str)
    end

  end
end
