FactoryGirl.define do

  factory :product_feature_value, class: Prestashop::Mapper::ProductFeatureValue do
    id_feature 1
    custom 1
    value 'Intel'

    id_lang 2
  end

  factory :product_feature_value_basic, class: Prestashop::Mapper::ProductFeatureValue do
    id_feature 1
    value 'Intel'

    id_lang 2
  end
end