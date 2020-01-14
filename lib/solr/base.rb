require "rsolr"
require "rsolr-ext"
require "kconv"

module Solr
  class Base < Rails::Application
    def self.solr
      @solr ||= RSolr::Ext.connect(url: Settings.solr.object_core.url,
                                   update_format: :json,
                                   open_timeout: Settings.solr.connection.open_timeout,
                                   read_timeout: Settings.solr.connection.read_timeout,
                                   retry_503: Settings.solr.connection.retry_503)
    end

    def self.add_data(job)
      solr.add id: job.id, name: job.name, company: job.company_name, industry: job.industries.pluck(:name), city: job.city_name, salary: job.salary, description: job.description
      solr.commit
    end

    def self.delete_data(id)
      solr.delete_by_id id
      solr.commit
    end

    def self.search(params)
      params[:search] ||= ""
      industry = params[:industry].present? ? "industry:\"#{escape(params[:industry])}\"" : "industry:*"
      city = params[:city].present? ? "city:\"#{escape(params[:city])}\"" : "city:*"
      response = solr.select params: { q: "name:*#{escape(params[:search])}*", fq: [industry, city], rows: Job.count }

      response["response"]["docs"]
    end

    def self.escape(str)
      RSolr.solr_escape(str)
    end

  end
end
