# frozen_string_literal: true

module DataMigration
  class RecipeFileSplitter
    UNITS = /(?:cup|tablespoon|teaspoon|ounce|pound|g|ml|oz|lb|pkg|package|cups|tablespoons|teaspoons|ounces|pounds|packages|slices|large|medium|small|can|cans|bottle|bottles|inch)/i
    OUTPUT_FILE = Rails.root.join('db/seeds/recipes.json')

    def initialize(input_file_path)
      @input_file_path = input_file_path
    end

    def call
      FileUtils.mkdir_p(File.dirname(OUTPUT_FILE))
      recipes = JSON.parse(File.read(@input_file_path))

      formatted_recipes = recipes.map do |recipe|
        recipe.delete('image')
        recipe['ingredients'] = normalize_ingredients(recipe['ingredients'])
        recipe
      end

      File.write(OUTPUT_FILE, JSON.pretty_generate(formatted_recipes))
      puts "Created #{OUTPUT_FILE}"
    end

    private

    def normalize_ingredients(ingredients)
      ingredients.map do |ingredient|
        if ingredient.is_a?(Hash)
          process_hash_ingredient(ingredient)
        else
          parse_string_ingredient(ingredient)
        end
      end
    end

    def process_hash_ingredient(ingredient)
      ingredient['name'] = normalize_name(ingredient['name']) if ingredient['name']

      if match = ingredient['quantity']&.match(%r{^([\d\s/½⅓¼⅔¾⅛⅜⅝⅞.]+)\s*(#{UNITS})$}i)
        ingredient['quantity'] = match[1].strip
        ingredient['measurement'] = match[2].strip
      else
        ingredient['measurement'] = nil
      end

      ingredient
    end

    def parse_string_ingredient(ingredient)
      ingredient = ingredient.gsub(/\([^)]*\)/, '').strip.downcase
      ingredient = ingredient.gsub(/\s+or\s+(bottle|can|jar|box|pkg|package)\b/i, '').strip

      if match = ingredient.match(%r{^([\d\s/½⅓¼⅔¾⅛⅜⅝⅞.]+)\s*(#{UNITS}s?)?\s*(.+)}i)
        quantity = match[1].strip
        unit = match[2]&.strip || nil
        remaining = normalize_name(match[3].strip)

        name_and_details = remaining.split(/,/, 2)
        name = name_and_details[0].strip
        details = name_and_details[1]&.strip || ''

        {
          'name' => name,
          'quantity' => quantity,
          'measurement' => unit,
          'details' => details
        }
      elsif match = ingredient.match(/^(.+?),\s*(.+)/i)
        name = normalize_name(match[1].strip)
        details = match[2].strip

        {
          'name' => name,
          'quantity' => '',
          'measurement' => nil,
          'details' => details
        }
      else
        {
          'name' => normalize_name(ingredient.strip),
          'quantity' => '',
          'measurement' => nil,
          'details' => ''
        }
      end
    end

    def normalize_name(name)
      if name.match?(%r{^\d+\s*/\s*\d+\s*-inch\s+}i) || name.match?(/^\d+(\.\d+)?\s*-inch\s+/i)
        name = name.sub(%r{^\d+\s*/\s*\d+\s*-inch\s+}i, '').sub(/^\d+(\.\d+)?\s*-inch\s+/i, '').strip
      end
      name.downcase
    end
  end
end
