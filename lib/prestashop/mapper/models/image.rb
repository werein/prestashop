using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Image < Model
      resource :images
      model :image

      def self.upload options = {}
        if options[:file].kind_of? Array
          images = []
          options[:file].each do |file|
            images << uploader(options[:resource], options[:id], file)
          end
          images.map{|i| i[:image][:id] } unless images.empty?
        else
          image = uploader(options[:resource], options[:id], options[:file])
          image[:image][:id] if image
        end if options[:file]
      end

      def self.uploader resource, id, source
        file = MiniMagick::Image.open(source)
        Client.current.connection.upload 'images', resource, id, payload(file), file
      rescue MiniMagick::Invalid
        nil # It's not valid image
      end

      def self.payload file
        { image: Faraday::UploadIO.new(file.path, 'image') }
      end
    end
  end
end