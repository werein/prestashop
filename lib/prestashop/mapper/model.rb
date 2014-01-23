using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Model
      include Extension
      extend Extension

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

      def hash_lang name, id_lang
        { language: { val: name, attr: { id: id_lang }}} if name
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