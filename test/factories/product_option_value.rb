FactoryGirl.define do

  factory :product_option_value, class: Prestashop::Mapper::ProductOptionValue do
    id_lang 2
    name '16GB'
    id_attribute_group 1
    color 0
  end
end