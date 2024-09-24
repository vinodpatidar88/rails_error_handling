require 'net/http'
require 'uri'
require 'json'

class ApiHandler
  def initialize(base_url, method = :get, params = {}, headers = {})
    @base_url = base_url
    @method = method
    @params = params
    @headers = headers
  end

  def result
    url = URI.join(@base_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')

    case @method
    when :get
      url.query = URI.encode_www_form(@params) if @params.any?
      request = Net::HTTP::Get.new(url)
    when :post
      request = Net::HTTP::Post.new(url)
      request.set_form_data(@params)
    else
      raise ArgumentError, "Unsupported HTTP method: #{@method}"
    end
    req_options = { use_ssl: url.scheme == 'https' }
    request['accept'] = 'application/json'
    request['content_type'] = 'application/json'

    @headers.each do |key, value|
      request[key] = value
    end

    response = Net::HTTP.start(url.hostname, url.port, req_options) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      begin
        JSON.parse(response.body)
      rescue StandardError
        response.body
      end
    else
      { error: "HTTP Error: #{response.code}", message: response.message }
    end
  end
end
