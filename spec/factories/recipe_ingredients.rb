# frozen_string_literal: true

FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    ingredient
    quantity { rand(1..5).to_s }
    measurement { %w[cup teaspoon tablespoon].sample }
  end
end
