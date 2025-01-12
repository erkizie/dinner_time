# frozen_string_literal: true

class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true
end

# == Schema Information
#
# Table name: recipes
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  cook_time  :integer
#  prep_time  :integer
#  ratings    :float
#  cuisine    :string
#  category   :string
#  author     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_recipes_on_ratings  (ratings)
#  index_recipes_on_title    (title)
#
