FactoryGirl.define do

  factory :image, class: Prestashop::Mapper::Image do
    resource 'products'
    id_resource 1
    source '/link/to/file.jpg'
  end

  factory :image_basic, class: Prestashop::Mapper::Image do
    resource 'products'
    id_resource 1
    source '/link/to/file.jpg'
  end
end