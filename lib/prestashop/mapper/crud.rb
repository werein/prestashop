module Prestashop
  module Mapper
    module Crud
      def self.included base
        base.send :extend, ClassMethods
      end
    end

    module ClassMethods

      # Create new resource, returns created resource, when passed or false when failed
      def create hash = {}
        result = Client.connection.create resource: self.resource, model: self.model, payload: hash
        result ? result[self.model] : nil
      end

      # Return true or false, if product exist or not
      def exists? id
        Client.connection.head resource: self.resource, id: id
      end

      # Find by id, returns hash with params
      def find id
        result = Client.connection.get resource: self.resource, id: id
        result ? result[self.model] : nil
      end

      # Find only one item, returns id
      def find_by options = {}
        results = where(options)
        results ? results.first : nil
      end

      # Return hash of all resources
      def all options = {}
        result = if options[:display] 
          Client.connection.get resource: self.resource, display: options[:display]
        else
          Client.connection.get resource: self.resource
        end
        handle_result result, options
      end
      
      # Find by conditionals, returns array of ids or nil
      def where options = {}
        result = Client.connection.get options.merge(resource: self.resource)
        handle_result result, options
      end

      # Update resource and return new informations
      def update id, hash = {}
        original = defined?(fixed_hash(nil)) ? fixed_hash(id) : find(id)
        if original
          original.merge!(hash)
          result = Client.connection.update resource: self.resource, model: self.model, id: id, payload: original
          result ? result[self.model] : nil
        else
          nil
        end
      end

      # Destroy with given id
      def destroy id
        Client.connection.delete resource: self.resource, id: id
      end

      private
        def handle_result result, options = {}
          if options[:display]
            if result[self.resource].kind_of?(Hash) and result[self.resource][self.model]
              objects = result[self.resource][self.model]
              objects.kind_of?(Array) ? objects : [objects]
            end
          else
            if result[self.resource].kind_of?(Hash) and result[self.resource][self.model]
              [objects = result[self.resource][self.model]]
              objects.kind_of?(Array) ? objects.map{ |o| o[:attr][:id] } : [ objects[:attr][:id] ]
            else
              nil
            end    
          end
        end
    end
  end
end