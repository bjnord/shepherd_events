require 'net/https'
require 'nokogiri'

class EventFetcherError < StandardError
end

class EventFetcher < ActiveRecord::Base
  def self.event_profiles(modified_since = nil)
    modified_since ||= 1.week.ago.to_date
    xml = http_get_xml("srv=event_profiles&modified_since=#{modified_since.strftime("%F")}")
    xml.xpath("//events/event")
  end

private

  def self.http_get_xml(options)
    uri = URI.parse(url = "#{APP_CONFIG['origin_url']}?#{options}")
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      # FIXME SECURITY peer verification not working; disable for now
      #http.verify_mode = OpenSSL::SSL::VERIFY_PEER 
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(APP_CONFIG['origin_user'], APP_CONFIG['origin_passwd'])
    Rails.logger.info("event_fetcher: HTTP GET request #{url}")
    begin
      response = http.request(request)
      Rails.logger.info("event_fetcher: HTTP GET response=#{response.code} #{response.message}")
      if !response.is_a?(Net::HTTPSuccess)
        raise EventFetcherError, "HTTP #{response.code}: #{response.message} on #{url}?#{options}"
      end
      xml = Nokogiri::XML(response.body)
    rescue => e
      raise EventFetcherError, "network error on #{url} -> #{e.message}"
    end
    errors = xml.xpath("//error").collect {|e| "#{e['type']}: #{e.text}" }
    raise EventFetcherError, "fetch server errors on #{options} -> #{errors.join(' -> ')}" if errors.length > 0
    xml
  end
end
