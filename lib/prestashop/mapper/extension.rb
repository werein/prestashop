module Prestashop
  module Mapper
    module Extension
      module ClassMethods
        def settings; Client.settings end

        # Return true or false, if product exist or not
        def exists? id
          Client.connection.head self.resource, id
        end

        # Find by id, returns hash with params
        def find id
          result = Client.connection.get self.resource, id
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
            Client.connection.get self.resource, nil, display: options[:display]
          else
            Client.connection.get self.resource
          end
          handle_result result, options
        end
        
        # Find by conditionals, returns array of ids or nil
        def where options = {}
          result = Client.connection.get self.resource, nil, options
          handle_result result, options
        end

        # Destroy with given id
        def destroy id
          Client.connection.delete self.resource, id
        end

        # Update resource and return new informations
        def update id, options = {}
          result = Client.connection.update self.resource, id, update_payload(id, options)
          result ? result[self.model] : nil
        end 

        def update_payload id, options
          original = defined?(fixed_hash(nil)) ? fixed_hash(id) : find(id)
          final = original.merge(options)
          Api::Converter.build(self.resource, self.model, final)
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
      
      module InstanceMethods
        def settings; Client.settings end

        # Create new resource, returns created resource, when passed or false when failed
        def create
          result = Client.connection.create self.class.resource, payload
          result ? result[self.class.model] : nil
        end

        def payload
          Api::Converter.build(self.class.resource, self.class.model, hash)
        end
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end