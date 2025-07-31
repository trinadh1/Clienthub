FactoryBot.define do
  factory :subscription do
    user { nil }
    stripe_customer_id { "MyString" }
    stripe_subscription_id { "MyString" }
    status { "MyString" }
    plan { "MyString" }
  end
end
