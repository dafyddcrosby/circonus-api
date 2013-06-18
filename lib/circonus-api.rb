require "circonus-api/version"
require "rest-client"
require "json"
require "uri"

module Circonus
  class Api
    def initialize(app_name=nil, api_token=nil)
      app_name  ||= ENV['CIRCONUS_APP_NAME']
      api_token ||= ENV['CIRCONUS_API_TOKEN']

      @resource = RestClient::Resource.new('https://api.circonus.com',
        :headers => {
          :x_circonus_app_name => app_name,
          :x_circonus_auth_token => api_token,
          :accept => 'application/json'
        }
      )
    end

    def self.resource( plural_name, singular_name = plural_name.gsub(/s$/, '') )
      define_method("list_#{plural_name}")     {            get("/#{singular_name}")              }
      define_method("show_#{singular_name}")   { |id|       get("/#{singular_name}/#{id}")        }
      define_method("create_#{singular_name}") { |data|     post("/#{singular_name}", data)       }
      define_method("update_#{singular_name}") { |id, data| put("/#{singular_name}/#{id}", data)  }
      define_method("delete_#{singular_name}") { |id|       delete("/#{singular_name}/#{id}")     }
    end

    resource "accounts"
    resource "annotations"
    resource "brokers"
    resource "check_bundles"
    resource "contact_groups"
    resource "graphs"
    resource "rule_sets"
    resource "templates"
    resource "users"
    resource "worksheets"

    def data_extraction(options = {})
      check_id = options.fetch(:check_id)
      metric_name = options.fetch(:metric_name)
      one_day_ago = Time.now - (60 * 60 * 24)
      start_time = options.fetch(:start, one_day_ago).to_i
      end_time = options.fetch(:end, Time.now).to_i
      type = options.fetch(:type, 'numeric') # can be numeric, text, or histogram

      params = {
        type: type,
        start: start_time,
        end: end_time,
      }

      unless type == 'text'
        period = options.fetch(:period, 300) # in seconds
        validate_data_extraction_period(period)
        params[:period] = period
      end

      get("/data/#{check_id}_#{metric_name}", params: params)
    end

    def get(path, params={})
      request(:get, path, params)
    end

    def put(path, params={})
      request(:put, path, params.to_json)
    end

    def post(path, params={})
      request(:post, path, params.to_json)
    end

    def delete(path, params={})
      request(:delete, path, params)
    end

    def request(method, path, params)
      begin
        response = @resource[URI.escape(path)].send(method, params)
        result = deserialize(response)
      rescue RestClient::Exception => e
        result = deserialize(e.http_body)
      end

      return result
    end

    def deserialize(json_string)
      JSON.parse(json_string)
    end

    private

    def validate_data_extraction_period(period)
      acceptable_periods = [300, 1800, 10800, 86400]
      unless acceptable_periods.include?(period)
        raise ArgumentError, "Period must be one of #{acceptable_periods.join(', ')} (in seconds)" 
      end
    end

  end
end
