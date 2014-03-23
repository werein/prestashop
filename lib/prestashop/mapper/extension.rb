module Prestashop
  module Mapper
    module Extension
      module ClassMethods

        # Determinate if model with class resource exists with given id
        #
        #   Car.exists?(1) # => true # if given car exist
        #   Car.exists?(2) # => false # if given car don't exist
        #
        def exists? id
          Client.check self.resource, id
        end

        # Find model by class resource and given id, returns hash
        # with all nodes, based on node name as key, node value as value
        #
        #   Car.find(1) # => { id: 1, name: 'BMW' }
        #   Car.find(2) # => nil
        #
        def find id
          result = Client.read self.resource, id
          result ? result[self.model] : nil
        end

        # Find model by class resource and params in hash
        # Returns first result, see #where for more informations
        #
        #   Car.find_by(name: 'BMW') # => 1
        #
        def find_by options = {}
          results = where(options)
          results ? results.first : nil
        end

        # Get models all results by class resource, you can specifi what
        # you should to see as result by specifiyng +:display+
        #
        #   Car.all # => [1,2,3]
        #   Car.all(display: ['name']) # => [{ name: { language: { attr: { id: 2, href: 'http://localhost.com/api/languages/2'}, val: 'BMW 7'} }]
        #
        def all options = {}
          result = if options[:display] 
            Client.read self.resource, nil, display: options[:display]
          else
            Client.read self.resource
          end
          handle_result result, options
        end
        
        # Get results by class resource and given conditionals
        #
        #   Car.where('filter[id_supplier' => 1) # => [1, 2]
        # 
        def where options = {}
          result = Client.read self.resource, nil, options
          handle_result result, options
        end

        # Destroy model by class resource and given id
        #
        #   Car.destroy(1) # => true
        #
        def destroy id
          Client.delete self.resource, id
        end

        # Create hash suitable for update, contains #fixed_hash as hash with deleted
        # keys, which shouldn't be in payload, if exist
        #
        #   Car.update_hash(1, name: 'BMW7') # => {name: 'BMW7', manufacturer: 'BMW'}
        #
        def update_hash id, options = {}
          original = defined?(fixed_hash(nil)) ? fixed_hash(id) : find(id)
          original.merge(options)
        end

        # Create payload for update, converts hash to XML
        #
        #   Car.update_payload(1, name: 'BMW 7') # => <prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><car><name><![CDATA[BMW 7]]></name></car></prestashop>
        #
        def update_payload id, options = {}
          Api::Converter.build(self.resource, self.model, update_hash(id, options))
        end

        # Update model, with class resource by +id+ and given updates
        #
        #   Car.update(1, name: 'BMW 7') # => {id: 1, name: 'BMW 7'}
        #
        def update id, options = {}
          result = Client.update self.resource, id, update_payload(id, options)
          result ? result[self.model] : nil
        end 

        private
          # Handle result to return +id+ or array with +ids+ of requested objects
          # 
          #   handle_result({ customers: { customer: [ 1,2 ] } }) # => [1, 2]
          #   handle_result({ customers: { customer: { attr: { id: 1 }} } }) # => [1]
          #
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

        # Generate hash with ID
        #
        #   car.hash_id(1) # => {id: 1}
        #
        def hash_id id
          { id: id } if id
        end

        # Make array of unique IDs in hash
        #
        #   car.hash_ids(1,2,3) # => [{id: 1},{id: 2},{id: 3}]
        # 
        def hash_ids ids
          ids.flatten.uniq.map{|id| hash_id(id)} if ids
        end

        # Create payload for create new object, coverts hash to XML
        #
        #   car.payload # => '<prestashop xmlns:xlink="http://www.w3.org/1999/xlink"><car><name><![CDATA[BMW 7]]></name><manufacturer><![CDATA[BMW]]></manufacturer></car></prestashop>'
        #
        def payload
          Api::Converter.build(self.class.resource, self.class.model, hash)
        end

        # Create new model from instance, based on class resource a payload generated from
        # hash method
        # 
        #   Car.new(name: 'BMW 7', manufacturer: 'BMW').create # => { id: 1, name: 'BMW 7', manufacturer: 'BMW' }
        # 
        def create
          result = Client.create self.class.resource, payload
          result ? result[self.class.model] : nil
        end
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end