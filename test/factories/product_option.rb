FactoryGirl.define do

  factory :product_option, class: Prestashop::Mapper::ProductOption do
    is_color_group 0
    position 1
    group_type 'select'
    name 'Capacity'
    public_name 'Capacity'

    id_lang 2
  end

  factory :product_option_basic, class: Prestashop::Mapper::ProductOption do
    name 'Capacity'

    id_lang 2
  end
end