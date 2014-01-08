require 'open-uri'
require 'tempfile'

module Prestashop
  module Api
    module Executor
      class << self
        def head conn, options = {}
          response = conn.connection.head conn.path(options)
          response.success? ? response.body : raise(RequestFailed.new(response))
        end

        def delete conn, options = {}
          response = conn.connection.delete conn.path(options)
          response.success? ? response.body : raise(RequestFailed.new(response))
        end

        def post conn, options = {}
          response = conn.connection.post conn.path(options), options[:payload]
          response.success? ? response.body : raise(RequestFailed.new(response))
        end

        def put conn, options = {}
          response = conn.connection.put conn.path(options), options[:payload]
          response.success? ? response.body : raise(RequestFailed.new(response))
        end

        def get conn, options = {}
          white_list = %w(filter display sort limit schema date)
          params = {}
          options.each do |name, value|
            if white_list.include? name.to_s.split('[').first
              params[name.to_sym] = value
            end
          end 

          response = conn.connection.get conn.path(options), params
          response.success? ? response.body : raise(RequestFailed.new(response))
        end

        def upload conn, options = {}
          extname = File.extname(options[:file])
          basename = File.basename(options[:file], extname)
          temp = Tempfile.new([basename, extname])
          temp.binmode
          temp.write open(options[:file]).read
          sleep(1)
          payload = { image: Faraday::UploadIO.new(temp.path, 'image') }
          response = conn.connection.post conn.upload_path(options), payload
          temp.close!
          response.success? ? response.body : raise(RequestFailed.new(response))
        rescue OpenURI::HTTPError => e
          # File doesn't exist
        end
      end
    end
  end
end