# frozen_string_literal: true

module DataMigration
  class RecipeSeeder
    def initialize(file_path)
      @file_path = file_path
    end

    def call
      recipes = JSON.parse(File.read(@file_path))
      recipes.each do |recipe_data|
        create_recipe_with_ingredients(recipe_data)
      end

      puts 'Recipes and ingredients successfully seeded!'
    end

    private

    def create_recipe_with_ingredients(recipe_data)
      recipe = Recipe.find_or_create_by!(
        title: recipe_data['title'],
        cook_time: recipe_data['cook_time'],
        prep_time: recipe_data['prep_time'],
        ratings: recipe_data['ratings'],
        cuisine: recipe_data['cuisine'],
        category: recipe_data['category'],
        author: recipe_data['author']
      )

      puts "Recipe created: #{recipe.title}"

      recipe_data['ingredients'].each do |ingredient_data|
        ingredient = Ingredient.find_or_create_by!(name: ingredient_data['name'])

        RecipeIngredient.find_or_create_by!(
          recipe: recipe,
          ingredient: ingredient,
          quantity: ingredient_data['quantity'],
          measurement: ingredient_data['measurement'],
          details: ingredient_data['details']
        )
      end
    end
  end
end
