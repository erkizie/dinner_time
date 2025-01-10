# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "ingredient_#{n}" }
  end
end
