FactoryGirl.define do

  factory :product_feature, class: Prestashop::Mapper::ProductFeature do
    position 0
    name 'CPU'

    id_lang 2
  end

  factory :product_feature_basic, class: Prestashop::Mapper::ProductFeature do
    name 'CPU'

    id_lang 2
  end
end