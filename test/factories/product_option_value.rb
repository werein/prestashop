FactoryGirl.define do

  factory :product_option_value, class: Prestashop::Mapper::ProductOptionValue do
    name '16GB'
    id_attribute_group 1
    color 0

    id_lang 2
  end
end