FactoryGirl.define do

  factory :supplier, class: Prestashop::Mapper::Supplier do
    active 1
    name 'Apple'
  end
end