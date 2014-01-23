FactoryGirl.define do

  factory :manufacturer, class: Prestashop::Mapper::Manufacturer do
    id 1
    active 1
    link_rewrite 'apple'
    name 'Apple'
    description 'Apple is company'
    short_description 'Apple is..'
    meta_title 'Apple'
    meta_description 'Apple is company'
    meta_keywords 'apple'

    id_lang 2
  end

  factory :manufacturer_basic, class: Prestashop::Mapper::Manufacturer do
    name 'Apple'

    id_lang 2
  end
end