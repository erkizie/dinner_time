# frozen_string_literal: true

ActiveRecord::Schema[7.2].define(version: 20_250_107_213_717) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'ingredients', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_ingredients_on_name', unique: true
  end

  create_table 'recipe_ingredients', force: :cascade do |t|
    t.bigint 'recipe_id', null: false
    t.bigint 'ingredient_id', null: false
    t.string 'quantity'
    t.string 'measurement'
    t.string 'details'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['ingredient_id'], name: 'index_recipe_ingredients_on_ingredient_id'
    t.index %w[recipe_id ingredient_id], name: 'index_recipe_ingredients_on_recipe_id_and_ingredient_id',
                                         unique: true
    t.index ['recipe_id'], name: 'index_recipe_ingredients_on_recipe_id'
  end

  create_table 'recipes', force: :cascade do |t|
    t.string 'title', null: false
    t.integer 'cook_time'
    t.integer 'prep_time'
    t.float 'ratings'
    t.string 'cuisine'
    t.string 'category'
    t.string 'author'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['ratings'], name: 'index_recipes_on_ratings'
    t.index ['title'], name: 'index_recipes_on_title'
  end

  add_foreign_key 'recipe_ingredients', 'ingredients'
  add_foreign_key 'recipe_ingredients', 'recipes'
end
