FactoryGirl.define do
  factory :event do
    sequence(:name) {|n| "Event #{n}" }
    sequence(:starts_at) do |n|
      t = Time.now + n.days + 1.hour
      t -= (t.to_i % 3600)
    end
    ends_at { starts_at + 2.hours }
  end
end
