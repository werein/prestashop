module Prestashop
  module Api
    module Refinement
      refine String do 
        def parse
          Converter.parse self
        end
        def parse_error
          Converter.parse_error self
        end
      end
    end
  end
end