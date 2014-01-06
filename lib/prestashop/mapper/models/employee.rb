module Prestashop
  module Mapper
    class Employee < Model
      resource :employees
      model :employee
    end
  end
end