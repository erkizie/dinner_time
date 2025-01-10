# frozen_string_literal: true

RSpec.describe RecipesQuery do
  describe '#call' do
    let!(:flour) { create(:ingredient, name: 'all-purpose flour') }
    let!(:honey) { create(:ingredient, name: 'honey') }
    let!(:salt) { create(:ingredient, name: 'salt') }

    let!(:recipe1) { create(:recipe, title: 'Honey Cake', ratings: 4.8) }
    let!(:recipe2) { create(:recipe, title: 'Perfect Pancakes', ratings: 4.5) }
    let!(:recipe3) { create(:recipe, title: 'Salty Bread', ratings: 3.9) }

    before do
      create(:recipe_ingredient, recipe: recipe1, ingredient: flour)
      create(:recipe_ingredient, recipe: recipe1, ingredient: honey)

      create(:recipe_ingredient, recipe: recipe2, ingredient: flour)
      create(:recipe_ingredient, recipe: recipe2, ingredient: honey)
      create(:recipe_ingredient, recipe: recipe2, ingredient: salt)

      create(:recipe_ingredient, recipe: recipe3, ingredient: salt)
    end

    it 'prioritizes recipes with a 100% match, regardless of the number of ingredients matched' do
      result = RecipesQuery.new(ingredients: ['all-purpose flour', 'honey', 'salt']).call
      expect(result.first).to eq(recipe1)
      expect(result.second).to eq(recipe2)
    end

    it 'returns recipes with partial matches when no 100% matches exist' do
      result = RecipesQuery.new(ingredients: ['all-purpose flour']).call
      expect(result).to match_array([recipe1, recipe2])
    end

    it 'does not include recipes with no matched ingredients' do
      result = RecipesQuery.new(ingredients: ['baking powder', 'vanilla']).call
      expect(result).to be_empty
    end

    it 'returns partial matches sorted by match percentage and ratings' do
      result = RecipesQuery.new(ingredients: ['all-purpose flour', 'honey']).call
      expect(result).to eq([recipe1, recipe2])
    end
  end
end
