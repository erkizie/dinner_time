# frozen_string_literal: true

class RecipesQuery
  def initialize(ingredients:)
    @ingredients = ingredients
  end

  def call
    available_ingredients = @ingredients.map { |i| ActiveRecord::Base.connection.quote(i.downcase) }.join(', ')

    Recipe
      .select("recipes.*,
               CASE
                 WHEN COUNT(DISTINCT ri.ingredient_id) = COUNT(DISTINCT CASE WHEN LOWER(i.name) IN (#{available_ingredients}) THEN ri.ingredient_id END)
                 THEN true
                 ELSE false
               END as is_perfect_match")
      .joins('JOIN recipe_ingredients ri ON ri.recipe_id = recipes.id')
      .joins('JOIN ingredients i ON i.id = ri.ingredient_id')
      .group('recipes.id')
      .having("COUNT(DISTINCT CASE WHEN LOWER(i.name) IN (#{available_ingredients}) THEN ri.ingredient_id END) > 0")
      .order(Arel.sql("
        CASE
          WHEN COUNT(DISTINCT ri.ingredient_id) = COUNT(DISTINCT CASE WHEN LOWER(i.name) IN (#{available_ingredients}) THEN ri.ingredient_id END)
          THEN 0
          ELSE 1
        END,
        ratings DESC"))
      .limit(3)
  end
end
