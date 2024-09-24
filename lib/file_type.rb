class FileType
  class << self
    def fetch_content_type(url)
        uri = URI.parse(url)
        response = nil
      
        # Use open-uri to fetch the headers of the URL
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          response = http.head(uri.request_uri)
        end
      
        content_type = response['content-type']
      
        # Return the content type
        content_type
    end
      
    def determine_file_type(content_type)
        return 'unknown' unless content_type
      
        if content_type.start_with?('image')
          'image'
        elsif content_type.start_with?('video')
          'video'
        else
          'unknown'
        end
    end
  end
end
