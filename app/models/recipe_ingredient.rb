class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
end

# == Schema Information
#
# Table name: recipe_ingredients
#
#  id            :bigint           not null, primary key
#  recipe_id     :bigint           not null
#  ingredient_id :bigint           not null
#  quantity      :string
#  details       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_recipe_ingredients_on_ingredient_id                (ingredient_id)
#  index_recipe_ingredients_on_recipe_id                    (recipe_id)
#  index_recipe_ingredients_on_recipe_id_and_ingredient_id  (recipe_id,ingredient_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (ingredient_id => ingredients.id)
#  fk_rails_...  (recipe_id => recipes.id)
#
