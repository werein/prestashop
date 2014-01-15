require 'open-uri'

using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Image < Model
      resource :images
      model :image

      attr_accessor :resource, :resource_id, :source, :file

      def initialize args = {}
        @resource    = args.fetch(:resource)
        @resource_id = args.fetch(:resource_id)
        @source      = args.fetch(:source)
      end

      def images
        source.kind_of?(Array) ? source : [source]
      end

      def upload
        result = []
        images.each do |image|
          result << uploader(image)
        end unless images.empty?
        result
      end

      def uploader source
        if source =~ URI::regexp
          self.file = MiniMagick::Image.open(source)
          result = Client.upload 'images', resource, resource_id, payload, file
          result[:image][:id] if result
        else
          false # Not valid url
        end
      rescue MiniMagick::Invalid
        false # It's not valid image
      end

      def payload
        { image: Faraday::UploadIO.new(file.path, 'image') }
      end
    end
  end
end