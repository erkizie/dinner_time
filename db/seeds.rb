# frozen_string_literal: true

splitter_output_path = Rails.root.join('db/seeds/recipes.json')

if File.exist?(splitter_output_path)
  puts "File #{splitter_output_path} already exists. Skipping RecipeFileSplitter."
else
  puts "File #{splitter_output_path} not found. Running RecipeFileSplitter..."
  DataMigration::RecipeFileSplitter.new(Rails.root.join('db/seeds/recipes-en.json')).call
end

# puts 'Running RecipeSeeder to populate the database...'
# DataMigration::RecipeSeeder.new(splitter_output_path).call
