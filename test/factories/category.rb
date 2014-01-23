FactoryGirl.define do

  factory :category, class: Prestashop::Mapper::Category do
    id_parent 2
    id_shop_default 1 
    active 1
    name 'Apple'
    description 'Apple category'

    id_lang 2
  end
end