FactoryGirl.define do

  factory :combination, class: Prestashop::Mapper::Combination do
    id 2
    id_product 2
    ean13 '1234567890123'
    quantity 10
    reference 'iphone-5s-32gb-white'
    supplier_reference '1'
    wholesale_price 12900
    price 16900
    ecotax 10.20
    weight 85
    minimal_quantity 1
    default_on 0
    vat 21
    price_vat 18900

    id_lang 2
  end

  factory :combination_basic, class: Prestashop::Mapper::Combination do
    id_product 2
    reference 'iphone-5s-32gb-white'

    id_lang 2
  end
end