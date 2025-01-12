# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :cook_time
      t.integer :prep_time
      t.float :ratings
      t.string :cuisine
      t.string :category
      t.string :author

      t.timestamps
    end

    add_index :recipes, :title
    add_index :recipes, :ratings
  end
end
