class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true

  def original_ingredients
    ingredients_details
  end

  def parsed_ingredient_names
    ingredients_details.map do |detail|
      extract_ingredient_name(detail)
    end
  end

  private

  def extract_ingredient_name(full_ingredient)
    clean = full_ingredient.gsub(%r{^\d+([/\d\s]*)?}, '')
    clean = clean.gsub(/\b(cup|cups|teaspoon|tablespoon|ounce|oz|can|bottle|quart|pound|grams|kg|ml|liter)\b/i, '')
    clean = clean.gsub(/\(.*?\)/, '')
    clean.strip.downcase
  end
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
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_recipes_on_ratings  (ratings)
#  index_recipes_on_title    (title)
#
