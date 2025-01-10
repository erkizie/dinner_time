# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    sequence(:title) { |n| "Recipe #{n}" }
    ratings { rand(3.0..5.0).round(1) }
    cook_time { rand(10..60) }
    prep_time { rand(10..30) }
  end
end
