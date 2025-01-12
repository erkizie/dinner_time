# frozen_string_literal: true

class Api::V1::RecipeSerializer
  def initialize(recipe)
    @recipe = recipe
  end

  def run
    return nil if @recipe.blank?

    {
      id: @recipe.id,
      title: @recipe.title,
      cook_time: @recipe.cook_time,
      prep_time: @recipe.prep_time,
      ratings: @recipe.ratings,
      cuisine: @recipe.cuisine,
      category: @recipe.category,
      author: @recipe.author,
      ingredients: @recipe.recipe_ingredients.includes(:ingredient).map do |ri|
        {
          quantity: ri.quantity,
          measurement: ri.measurement,
          name: ri.ingredient.name,
          details: ri.details
        }
      end
    }
  end
end
