# unless defined?(Rails)
#   require 'active_resource'
#   require 'active_support'
#   require 'action_view'
#   require 'action_view/helpers'

#   include ActionView::Helpers
# end

module Prestashop
  module Mapper
    class Model
      include Crud

      def settings; Client.settings; end
      def self.settings; Client.settings; end

      def create
        self.class.send(:create, hash)
      end

      def update id, update
        self.class.send(:update, id, update)
      end
        
      # Meta title is same as name, when is not given
      def meta_title
        @meta_title ? @meta_title.plain.truncate(61) : name
      end

      # Meta description is same as description, when is not given
      def meta_description
        @meta_description ? @meta_description.restricted.truncate(252) : ( description_short.plain if description_short )
      end

      # Meta keywords are generated from name, when are not given
      def meta_keywords
        @meta_keywords ? @meta_keywords.plain.truncate(61) : name.split(' ').join(', ')
      end

      def lang value = nil
        { language: { val: value, attr: { id: settings.id_language }}} if value
      end

      class << self
        def resource value = nil
          value.nil? ? @resource : @resource = value
        end

        def model value = nil
          value.nil? ? @model : @model = value
        end
      end
    end    
  end
end