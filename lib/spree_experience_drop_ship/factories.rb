FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_experience_drop_ship/factories'
  factory :experience, :class => Spree::Experience do
    sequence(:name) { |i| "Big Store #{i}" }
    email { FFaker::Internet.email }
    url "http://example.com"
    address
    # Creating a stock location with a factory instead of letting the model handle it
    # so that we can run tests with backorderable defaulting to true.
  end

  factory :experience_user, parent: :user do
    experience
  end

  factory :variant_with_experience, parent: :variant do
    after :create do |variant|
      variant.product.add_experience! create(:experience)
    end
  end
end
