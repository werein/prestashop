FactoryGirl.define do

  factory :product, class: Prestashop::Mapper::Product do
    id_shop_default 1
    id_supplier 1
    name 'Apple iPhone'
    description 'Apple iPhone is a mobile phone..'
    description_short 'Apple iPhone is..'
    reference 'apple-iphone'
    vat 0
    original_price 100
    available_now 'Available now'
    available_later 'Available later'

    id_lang 2
  end
end