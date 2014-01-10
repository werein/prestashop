using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class CustomerThread < Model
      resource :customer_threads
      model :customer_thread
    end
  end
end