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
      # * +:resource+ [String, Symbol] - Resource of requested item.
      # * +:id+       [Integer, Array] - Requested object id or ids.
      #
      # ==== Example:
      #   path(:customers, 1) # => "customers/1"
      #
      def path resource, id = nil
        path = resource.to_s
        path += id.kind_of?(Array) ? "?id=[#{id.join(',')}]" : "/#{id}" if id
        path
      end

      # Generate path for API upload request
      #
      # ==== Parameters:
      # * +:type+       - Type as Image
      # * +:resource+   - Resource of requested item
      # * +:id+         - Requested object id
      #
      def upload_path type, resource, id
        "#{type}/#{resource}/#{id}"
      end

      # Call HEAD on WebService API, returns +true+ if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +resource+  - Resource of requested item
      # * +id+        - ID of requested item, not required
      #
      def head resource, id = nil
        response = connection.head path(resource, id)
        if response.success?
          true # response.body 
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      end
      alias :check :head

      # Call GET on WebService API, returns parsed Prestashop response or raise error, when request failed.
      #
      # ==== Parameters:
      # * +resource+  - Resource of requested item
      # * +id+        - ID of requested item, not required
      # * +opts+      - Param name, value based on Hash key and value.
      #
      def get resource, id = nil, opts = {}
        white_list = %w(filter display sort limit schema date)
        params = {}
        opts.each do |name, value|
          if white_list.include? name.to_s.split('[').first
            params[name.to_sym] = value
          end
        end 

        response = connection.get path(resource, id), params
        if response.success? 
          response.body.parse
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      end
      alias :read :get

      # Call POST on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +:resource+ - Resource of requested item
      # * +:payload+  - posted attachement
      #
      def post resource, payload
        response = connection.post path(resource), payload
        if response.success? 
          response.body.parse
        else
          raise RequestFailed.new(response), "#{response.body.parse_error}. XML SENT: #{payload}"
        end
      end
      alias :create :post

      # Call PUT on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +:resource+ - Resource of requested item
      # * +:id+       - ID of updated item
      # * +:payload+  - posted attachement
      #
      def put resource, id, payload
        response = connection.put path(resource, id), payload
        if response.success?
          response.body.parse
        else
          raise RequestFailed.new(response), "#{response.body.parse_error}. XML SENT: #{payload}"
        end
      end
      alias :update :put

      # Call DELETE on WebService API, returns +true+ if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +:resource+ - Resource of requested item
      # * +:id+       - ID of deleted item
      #
      def delete resource, id
        response = connection.delete path(resource, id)
        if response.success?
          true # response.body
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      end

      # Send file via payload After that call POST on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.
      #
      # ==== Parameters:
      # * +type+      - Type (image, attachement)
      # * +resource+  - Resource of uploaded item
      # * +id+        - ID of uploaded item
      # * +payload+   - Attachement in hash with file path
      # * +file+      - Original file
      #
      def upload type, resource, id, payload, file
        response = connection.post upload_path(type, resource, id), payload
        file.destroy!
        if response.success?
          response.body.parse
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      end

      # Test connection based on current credentials and connection, return true or false, based if request was successfull or not.
      def test
        connection.get.status == 200 ? true : false
      end
    end
  end
end