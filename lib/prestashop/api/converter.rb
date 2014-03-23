require 'nokogiri'

module Prestashop
  module Api
    module Converter

      # Build XML from given params and hash. This XML is compatible with Prestashop WebService
      #
      #   Converter.build :customers, :customer, { name: 'Steve' }  # => <prestashop><customers><customer>....</customer></customers></prestashop>
      #
      def self.build resource, model, hash
        Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |ml|
          ml.prestashop("xmlns:xlink" => "http://www.w3.org/1999/xlink") {
            ml.send(model.to_s) {
              build_nodes ml, hash
            }
          }
        end.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
      end

      # Parse XML (response from WebService call) to Hash, skipping first <prestashop> node.
      #
      #   Converter.parse('<prestashop><customers><customer><name>Steve</customer></customers></prestashop>')
      #   # => {customers: [ customer: { name: 'Steve' } ]}
      #
      def self.parse xml
        result = Nokogiri::XML xml

        raise ParserError unless result.root

        xml_node_to_hash result.root
      end

      # Parse XML to Hash, call parse and skip everything to error message
      #
      def self.parse_error response
        parsed = parse(response)
        if parsed[:errors] and parsed[:errors][:error] and parsed[:errors][:error][:message]
          parsed[:errors][:error][:message]
        else
          raise ParserError
        end
      end

      # Build XML nodes based from given source parameter, skipping +attr+ or +val+ keys if source is Hash
      #
      # ==== Parameters:
      # * +ml+ - Current XML
      # * +source+ - Source, which will be converted into the XML
      #
      def self.build_nodes ml, source, mkey = nil
        unless source[:attr] and source[:val]
          source.each do |key, value| 
            if value.kind_of? Hash
              if value[:attr]
                ml.send(key, value[:attr]){
                  cdata ml, value[:val]
                  build_nodes ml, value
                }
              elsif key != :attr
                ml.send(key){
                  unless value.kind_of? Hash
                    cdata ml, value
                  end
                  build_nodes ml, value
                }
              end
            elsif value.kind_of? Array
              value.each do |item|
                hash = {}
                hash[key] = item
                build_nodes ml, hash
              end
            elsif key != :val
              ml.send(key){
                cdata ml, value
              }
            end
          end if source.kind_of? Hash
        end
      end

      # Create CDATA tag into XML, when is not empty
      #
      def self.cdata ml, value
        if value and value != ''
          ml.cdata value
        end
      end

      # Parse XML node and covert it to hash
      #
      #   Converter.xml_node_to_hash '<customer id_lang="1">Steve</customer>'
      #   # => { attr: { id_lang: 1 }, val: 'Steve'  }
      #
      def self.xml_node_to_hash node 
        # If we are at the root of the document, start the hash
        if node.element?
          result_hash = {}
          if node.attributes != {}
             if node.attributes
              node.attributes.each do |key, value|
                unless value.name == 'href'
                  result_hash[:attr] = {} unless result_hash[:attr]
                  result_hash[:attr][value.name.to_sym] = prepare(value.value)
                end
              end
            end
          end
          if node.children.size > 0
            node.children.each do |child|
              result = xml_node_to_hash(child)
              if child.name == "text"
                unless child.next_sibling || child.previous_sibling
                  if !result_hash.empty?
                    result_hash[:val] = prepare(result)
                    return result_hash
                  end
                  return prepare(result)
                end
              elsif child.name == "#cdata-section"
                if !result_hash.empty?
                  result_hash[:val] = prepare(result)
                  return result_hash
                end
                return prepare(result)
              elsif result_hash[child.name.to_sym]
                if result_hash[child.name.to_sym].is_a?(Object::Array)
                  result_hash[child.name.to_sym] << prepare(result)
                else
                  result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << prepare(result)
                end
              else 
                result_hash[child.name.to_sym] = prepare(result)
              end
            end
   
            return result_hash
          else
            return result_hash
          end 
        else 
          return prepare(node.content.to_s) 
        end 
      end

      def self.prepare data
        (data.class == String && data.to_i.to_s == data) ? data.to_i : data
      end
    end
  end
end