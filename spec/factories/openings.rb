# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :opening do
    lat 40.0150
    lng 105.2700
    truck {FactoryGirl.build :truck}
  end
end
