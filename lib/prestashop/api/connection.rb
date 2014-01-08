require 'faraday'

module Prestashop
  module Api
    class Connection
      attr_reader :api_key, :api_url

      def initialize api_key, api_url
        @api_key = api_key
        self.api_url = api_url

        raise InvalidCredentials unless self.test
      end

      def api_url= url
        url.gsub!(/^(http|https):\/\//,'')
        url = 'http://' + url
        url << '/' unless url.end_with? '/'
        url << 'api/' unless url.end_with? 'api/'
        @api_url = url
      end

      def connection
        Faraday.new do |builder|
          builder.url_prefix = api_url
          builder.request     :multipart
          builder.request     :url_encoded
          builder.response    :logger
          builder.adapter     :net_http
          builder.basic_auth  api_key, ''
        end
      end

      def path options
        path = options[:resource].to_s
        path += options[:id].kind_of?(Array) ? "?id=[#{options[:id].join(',')}]" : "/#{options[:id]}" if options[:id]
        path
      end

      def upload_path options
        "#{options[:type]}/#{options[:resource]}/#{options[:id]}"
      end

      # Call GET on WebService API
      def get options = {}
        begin 
          response = Executor.get self, options
          Converter.from_xml response
        rescue RequestFailed => e
          response = Converter.parse_error e.response.body
          raise RequestFailed.new(e), response
        end
      end

      # Call Head on WebService API
      def head options
        begin
          Executor.head self, options
          true
        rescue RequestFailed => e
          response = Converter.parse_error e.response.body
          raise RequestFailed.new(e), response
        end
      end

      # Call create on WebService API
      def create options
        begin
          options[:payload] = Converter.to_xml(options[:resource], options[:model], options[:payload]) if options[:payload]
          response = Executor.post self, options
          Converter.from_xml response
        rescue RequestFailed => e
          response = Converter.parse_error e.response.body
          raise RequestFailed.new(e), "#{response}. XML SENT: #{options[:payload]}"
        end
      end

      # Call update on WebService API
      def update options
        begin
          options[:payload] = Converter.to_xml(options[:resource], options[:model], options[:payload].merge(id: options[:id])) if options[:payload]
          response = Executor.put self, options
          Converter.from_xml response
        rescue RequestFailed => e
          response = Converter.parse_error e.response.body
          raise RequestFailed.new(e), "#{response}. XML SENT: #{options[:payload]}"
        end
      end

      # Call delete on WebService API
      def delete options
        begin
          Executor.delete self, options
          true
        rescue RequestFailed => e
          response = Converter.parse_error e.response.body
          raise RequestFailed.new(e), response
        end
      end

      # Upload file
      def upload options
        begin
          response = Executor.upload self, options
          Converter.from_xml response
        rescue => e
          # Don't raise error (yet), when image isn't readable
          # raise e 
        end
      end

      # Test connection
      def test
        connection.get.status == 200 ? true : false
      end
    end
  end
end