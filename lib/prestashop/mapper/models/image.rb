require 'open-uri'

using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Image < Model
      resource :images
      model :image

      attr_accessor :id, :resource, :id_resource, :source, :file

      def initialize args = {}
        @id          = args[:id]
        @resource    = args.fetch(:resource)
        @id_resource = args.fetch(:id_resource)
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
          source = URI::encode(source)
          self.file = MiniMagick::Image.open(source)
          file.format 'png' unless %w(jpg jpeg png gif).include?(file[:format])
          result = Client.upload 'images', resource, id_resource, payload, file
          result[:image][:id] if result
        else
          false # Not valid url
        end
      rescue MiniMagick::Invalid
        false # It's not valid image
      rescue OpenURI::HTTPError
        false # Image not found
      end

      def payload
        { image: Faraday::UploadIO.new(file.path, 'image') }
      end
    end
  end
end