FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "item #{n}" }
    sell_in { 20 }
    quality { rand 50 }
  end
end
