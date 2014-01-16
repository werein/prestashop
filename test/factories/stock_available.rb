FactoryGirl.define do

  factory :stock_available, class: Prestashop::Mapper::StockAvailable do
    id 1
    id_product 1
    id_product_attribute 3
    id_shop 1
    id_shop_group 0
    quantity 10
    depends_on_stock 0
    out_of_stock 2
  end

  factory :stock_available_basic, class: Prestashop::Mapper::StockAvailable do
    id_product 1
    quantity 10
  end
end