FactoryGirl.define do
  factory :resource do
    event
    sequence(:name) {|n| "Resource #{n}" }
  end
end
