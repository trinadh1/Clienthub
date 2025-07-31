FactoryBot.define do
  factory :invoice do
    due_date { "2025-07-21" }
    total_amount { "9.99" }
    project { nil }
  end
end
