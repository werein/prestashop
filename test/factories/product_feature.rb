FactoryGirl.define do

  factory :product_feature, class: Prestashop::Mapper::ProductFeature do
    id_lang 2
    position 0
    name 'CPU'
  end

  factory :product_feature_basic, class: Prestashop::Mapper::ProductFeature do
    id_lang 2
    name 'CPU'
  end
end