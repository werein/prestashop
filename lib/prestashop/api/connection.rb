require 'faraday'
require 'mini_magick'
require 'tempfile'

using Prestashop::Api::Refinement
module Prestashop
  module Api
    class Connection
      attr_reader :api_key, :api_url

      # Create new connection. Raise error, when is not possible validate connection from any reason
      #
      #   Prestashop::Api::Connection.new 'TOKEN342', 'mystore.com'
      #
      def initialize api_key, api_url
        @api_key = api_key
        self.api_url = api_url

        raise InvalidCredentials unless self.test
      end

      # Convert url to  suitable for Prestashop API
      #
      #   @connection.api_url = 'mystore.com' # => http://mystore.com/api/
      # 
      def api_url= url
        url.gsub!(/^(http|https):\/\//,'')
        url = 'http://' + url
        url << '/' unless url.end_with? '/'
        url << 'api/' unless url.end_with? 'api/'
        @api_url = url
      end

      # Create connection based on connection instance, returns +Faraday::Connection+ 
      # which can be usedo for API call
      #
      def connection
        Faraday.new do |builder|
          builder.url_prefix = api_url
          builder.request     :multipart
          builder.request     :url_encoded
          builder.request     :retry, 5
          # builder.response    :logger
          builder.adapter     :net_http
          builder.basic_auth  api_key, ''
        end
      end

      # Generate path for API request
      #
      #   path(:customers, 1) # => "customers/1"
      #   path(:customers, [1, 5]) # => "customers?id=[1,5]"
      #
      def path resource, id = nil
        path = resource.to_s
        path += id.kind_of?(Array) ? "?id=[#{id.join(',')}]" : "/#{id}" if id
        path
      end

      # Generate path for API upload request
      #
      #   upload_path :image, :products, 2 # => /images/products/2
      #
      def upload_path type, resource, id
        "#{type}/#{resource}/#{id}"
      end

      # Call HEAD on WebService API, returns +true+ if was request successfull or raise error, when request failed.
      # Can be called as +check+ instead +head+
      #
      #   head :customer, 2 # => true
      #   check :customer, 3 # => true
      #
      def head resource, id = nil
        raise ArgumentError, "resource: #{resource} must be string or symbol" unless resource.kind_of?(String) or resource.kind_of?(Symbol)
        raise ArgumentError, "id: #{id} must be integer or nil" unless id.to_i.kind_of?(Integer) or id == nil
        
        request_path = path(resource, id)
        response = connection.head request_path
        if response.success?
          true # response.body 
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      rescue ParserError
        raise ParserError, "Response couldn't be parsed for: #{request_path}. RESPONSE: #{response.body}"
      end
      alias :check :head

      # Call GET on WebService API, returns parsed Prestashop response or raise error, when request failed.
      # Can be called as +read+ instead +get+
      #
      #   get :customer, 1       # => {id: 1 ...}
      #   read :customer, [1,2]    # => [{id: 1}, {id: 2}]
      #
      # available options::
      #   * filter
      #   * display
      #   * sort
      #   * limit
      #   * schema
      #   * date
      #
      def get resource, id = nil, opts = {}
        id.to_i unless id.kind_of?(Array)
        raise ArgumentError, "resource: #{resource} must be string or symbol" unless resource.kind_of?(String) or resource.kind_of?(Symbol)
        raise ArgumentError, "id: #{id} must be integer, array or nil" unless id.kind_of?(Integer) or id.kind_of?(Array) or id == nil

        white_list = %w(filter display sort limit schema date)
        params = {}
        opts.each do |name, value|
          if white_list.include? name.to_s.split('[').first
            params[name.to_sym] = value
          end
        end 

        request_path = path(resource, id)
        response = connection.get request_path, params
        if response.success? 
          response.body.parse
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      rescue ParserError
        raise ParserError, "Response couldn't be parsed for: #{request_path} with #{params}. RESPONSE: #{response.body}"
      end
      alias :read :get

      # Call POST on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.
      # Can be called as +create+ insted of +put+
      #
      #   post :customer, { name: 'Steve' } # => true
      #
      def post resource, payload
        raise ArgumentError, "resource: #{resource} must be string or symbol" unless resource.kind_of?(String) or resource.kind_of?(Symbol)

        request_path = path(resource)
        response = connection.post request_path, payload
        if response.success? 
          response.body.parse
        else
          raise RequestFailed.new(response), "#{response.body.parse_error}. XML SENT: #{payload}"
        end
      rescue ParserError
        raise ParserError, "Response couldn't be parsed for: #{request_path}. RESPONSE: #{response.body} XML SENT: #{payload}"
      end
      alias :create :post

      # Call PUT on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.
      # Can be called as +update+ instead +put+
      #
      #   put :customer, 1, {surname: 'Jobs'} # => true
      #   update :customer, 1, {nope: 'Jobs'} # => false
      #
      def put resource, id, payload
        raise ArgumentError, "resource: #{resource} must be string or symbol" unless resource.kind_of?(String) or resource.kind_of?(Symbol)
        raise ArgumentError, "id: #{id} must be integer" unless id.to_i.kind_of?(Integer)

        request_path = path(resource, id)
        response = connection.put request_path, payload
        if response.success?
          response.body.parse
        else
          raise RequestFailed.new(response), "#{response.body.parse_error}. XML SENT: #{payload}"
        end
      rescue ParserError
        raise ParserError, "Response couldn't be parsed for: #{request_path}. RESPONSE: #{response.body} XML SENT: #{payload}"
      end
      alias :update :put

      # Call DELETE on WebService API, returns +true+ if was request successfull or raise error, when request failed.
      #
      #   delete :customer, 1 # => true
      #
      def delete resource, id
        raise ArgumentError, "resource: #{resource} must be string or symbol" unless resource.kind_of?(String) or resource.kind_of?(Symbol)
        raise ArgumentError, "id: #{id} must be integer" unless id.to_i.kind_of?(Integer)

        request_path = path(resource, id)
        response = connection.delete request_path
        if response.success?
          true # response.body
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      rescue ParserError
        raise ParserError, "Response couldn't be parsed for: #{request_path}. RESPONSE: #{response.body} XML SENT: #{payload}"
      end
      alias :destroy :delete


      # Send file via payload After that call POST on WebService API, returns parsed Prestashop response if was request successfull or raise error, when request failed.
      #
      #  upload :image, :customer, 2, {image: '/file/to/path.png'}, file
      #
      # @param  type [Type (image, attachement)]
      # @param  resource [Resource of uploaded item]
      # @param  id [ID of uploaded item]
      # @param  payload [Attachement in hash with file path]
      # @param  file [Original file]
      # 
      def upload type, resource, id, payload, file
        raise ArgumentError, "type: #{type} must be string or symbol" unless resource.kind_of?(String) or resource.kind_of?(Symbol)
        raise ArgumentError, "resource: #{resource} must be string or symbol" unless resource.kind_of?(String) or resource.kind_of?(Symbol)
        raise ArgumentError, "id: #{id} must be integer" unless id.to_i.kind_of?(Integer)

        request_path = upload_path(type, resource, id)
        response = connection.post request_path, payload
        file.destroy!
        if response.success?
          response.body.parse
        else
          raise RequestFailed.new(response), response.body.parse_error
        end
      rescue ParserError
        raise ParserError, "Response couldn't be parsed for: #{request_path}. RESPONSE: #{response.body} XML SENT: #{payload}"
      end

      # Test connection based on current credentials and connection, return true or false, based if request was successfull or not.
      def test
        connection.get.status == 200 ? true : false
      end
    end
  end
end