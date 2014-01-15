FactoryGirl.define do

  factory :product_option, class: Prestashop::Mapper::ProductOption do
    id_lang 2
    is_color_group 0
    position 1
    group_type 'select'
    name 'Capacity'
    public_name 'Capacity'
  end

  factory :product_option_basic, class: Prestashop::Mapper::ProductOption do
    id_lang 2
    name 'Capacity'
  end
end