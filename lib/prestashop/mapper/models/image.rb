module Prestashop
  module Mapper
    class Image < Model
      resource :images
      model :image

      def self.upload options = {}
        if options[:file].kind_of? Array
          images = []
          options[:file].each do |file|
            images << Client.current.connection.upload(options.merge!(type: 'images', file: file))
          end
          images.map{|i| i[:image][:id] } unless images.empty?
        else
          image = Client.current.connection.upload options.merge!(type: 'images')
          image[:image][:id] if image
        end if options[:file]
      end
    end
  end
end