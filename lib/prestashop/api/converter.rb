require 'nokogiri'

module Prestashop
  module Api
    module Converter
      def self.to_xml resource, model, hash
        Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |ml|
          ml.prestashop("xmlns:xlink" => "http://www.w3.org/1999/xlink") {
            ml.send(model.to_s) {
              create_nodes ml, hash
            }
          }
        end.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
      end

      def self.from_xml xml
        result = Nokogiri::XML xml
        xml_node_to_hash result.root
      end

      def self.parse_error response
        from_xml(response)[:errors][:error][:message]
      end

      def self.create_nodes ml, source, mkey = nil
        unless source[:attr] and source[:val]
          source.each do |key, value| 
            if value.kind_of? Hash
              if value[:attr]
                ml.send(key, value[:attr]){
                  cdata ml, value[:val]
                  create_nodes ml, value
                }
              elsif key != :attr
                ml.send(key){
                  unless value.kind_of? Hash
                    cdata ml, value
                  end
                  create_nodes ml, value
                }
              end
            elsif value.kind_of? Array
              value.each do |item|
                hash = {}
                hash[key] = item
                create_nodes ml, hash
              end
            elsif key != :val
              ml.send(key){
                cdata ml, value
              }
            end
          end if source.kind_of? Hash
        end
      end

      def self.cdata ml, value
        if value and value != ''
          ml.cdata value
        end
      end

      def self.xml_node_to_hash(node) 
        # If we are at the root of the document, start the hash
        if node.element?
          result_hash = {}
          if node.attributes != {}
            result_hash[:attr] = {}
            node.attributes.each do |key, value|
              result_hash[:attr][value.name.to_sym] = prepare(value.value)
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

      def self.prepare(data)
        (data.class == String && data.to_i.to_s == data) ? data.to_i : data
      end
    end
  end
end