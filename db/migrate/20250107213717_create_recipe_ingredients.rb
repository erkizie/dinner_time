# frozen_string_literal: true

class CreateRecipeIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.string :quantity
      t.string :measurement
      t.string :details

      t.timestamps
    end

    add_index :recipe_ingredients, %i[recipe_id ingredient_id], unique: true
  end
end
