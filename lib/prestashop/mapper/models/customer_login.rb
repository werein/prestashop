using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class CustomerLogin < Model
      resource :customer_login
      model :customer

      def self.authorize(id, password)
        result = Client.read self.resource, id, 'filter[passwd]' => password
        result = {self.resource => {self.model => result[:customer]}} unless result.nil?
        result = handle_result result, display: 'full'
        auth_user = result ? result.first : nil
        return nil if auth_user.nil? || auth_user[:successfull][:val] != 'true'
        auth_user
      end
    end
  end
end