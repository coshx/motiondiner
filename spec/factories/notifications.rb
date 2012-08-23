# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    truck {FactoryGirl.build :truck}
  end
end
