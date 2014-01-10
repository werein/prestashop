require 'faraday'
require 'mini_magick'
require 'tempfile'

using Prestashop::Api::Refinement
module Prestashop
  module Api
    class Connection
      attr_reader :api_key, :api_url

      # Initialize new connection, raise error, when connection test failed.
      def initialize api_key, api_url
        @api_key = api_key
        self.api_url = api_url

        raise InvalidCredentials unless self.test
      end

      # Convert given url to url suitable for Prestashop API
      #
      # ==== Parameters:
      # * +url+ - URL with Prestashop store.
      #
      def api_url= url
        url.gsub!(/^(http|https):\/\//,'')
        url = 'http://' + url
        url << '/' unless url.end_with? '/'
        url << 'api/' unless url.end_with? 'api/'
        @api_url = url
      end

      # Create connection based on connection instance, returns +Faraday::Connection+ suitable for API call
      def connection
        Faraday.new do |builder|
          builder.url_prefix = api_url
          builder.request     :multipart
          builder.request     :url_encoded
          # builder.response    :logger
          builder.adapter     :net_http
          builder.basic_auth  api_key, ''
        end
      end

      # Generate path for API request
      #
      # ==== Parameters:
      # opts [Hash]::
      #   * +:resource+ [String, Symbol] - Resource of requested item.
      #   * +:id+       [Integer, Array] - Requested object id or ids.
      #
      # ==== Example:
      #   path(resource: :customers, id: 1) # => customers/1 
      #
      def path opts = {}
        path = opts[:resource].to_s
        path += opts[:id].kind_of?(Array) ? "?id=[#{opts[:id].join(',')}]" : "/#{opts[:id]}" if opts[:id]
        path
      end

      # Generate path for API upload request
      #
      # ==== Parameters:
      # opts [Hash]::
      #   * +:type+       - Type as Image
      #   * +:resource+   - Resource of requested item
      #   * +:id+         - Requested object id
      #
      def upload_path opts = {}
        "#{opts[:type]}/#{opts[:resource]}/#{opts[:id]}"
      end

      # Call GET on WebService API, returns parsed Prestashop response or raise error, when request failed.
      #
      # ==== Parameters:
      # * +opts+ - with options for generate path (see #path) and param name, value based on Hash key and value.
      #
      def get opts = {}
        white_list = %w(filter display sort limit schema date)
        params = {}
        opts.each do |name, value|
          if white_list.include? name.to_s.split('[').first
            params[name.to_sym] = value
          end
        end 

        response = connection.get path(opts), params
        if response.success? 
          response.body.parse
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      end

      # Call HEAD on WebService API, returns +true+ if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +opts+ - with options for generate path (see #path)
      #
      def head options
        response = connection.head path(options)
        if response.success?
          true # response.body 
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      end

      # Call POST on WebService API, eturns parsed Prestashop response if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +opts+ - with options for generate path (see #path)
      # opts::
      #   * +:model+    - model name, singural or resource
      #   * +:payload+  - posted attachement
      #
      def create options
        response = connection.post path(options), payload(options)
        if response.success? 
          response.body.parse
        else
          raise RequestFailed.new(response), "#{response.body.parse_error}. XML SENT: #{payload}"
        end
      end

      # Call PUT on WebService API, eturns parsed Prestashop response if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +opts+ - with options for generate path (see #path)
      # opts::
      #   * +:model+    - model name, singural or resource
      #   * +:payload+  - posted attachement
      #
      def update options
        response = connection.put path(options), payload(options)
        if response.success?
          response.body.parse
        else
          raise RequestFailed.new(response), "#{response.body.parse_error}. XML SENT: #{payload}"
        end
      end

      # Call DELETE on WebService API, returns +true+ if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +opts+ - with options for generate path (see #path)
      #
      def delete options
        response = connection.delete path(options)
        if response.success?
          true # response.body
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      end

      # Download file from URL and save it to temporary file. After that call POST on WebService API, returns +true+ if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +opts+ - with options for generate path (see #upload_path)
      # opts::
      #   * +file+ - url link to file, which should be uploaded
      def upload options
        image = MiniMagick::Image.open(options[:file])
        payload = { image: Faraday::UploadIO.new(image.path, 'image') }
        response = connection.post upload_path(options), payload
        image.destroy!
        
        if response.success?
          response.body.parse
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      rescue MiniMagick::Invalid
        # It's not valid image
      end

      # Test connection based on current credentials and connection, return true or false, based if request was successfull or not.
      def test
        connection.get.status == 200 ? true : false
      end

      # Build payload from given options
      def payload options = {}
        Converter.build(options[:resource], options[:model], options[:payload].merge(id: options[:id]))
      end
    end
  end
end