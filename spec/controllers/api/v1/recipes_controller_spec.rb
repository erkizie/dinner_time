# frozen_string_literal: true

RSpec.describe Api::V1::RecipesController, type: :controller do
  describe 'GET /api/v1/recipes/search' do
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

    context 'when recipes match the provided ingredients' do
      it 'returns matching recipes' do
        get :search, params: { ingredients: ['all-purpose flour', 'honey'] }
        expect(response).to have_http_status(:ok)
        expect(json_response['data']['recipes'].map { |r| r['title'] }).to include('Honey Cake', 'Perfect Pancakes')
      end
    end

    context 'when some recipes partially match the provided ingredients' do
      it 'returns recipes with partial matches' do
        get :search, params: { ingredients: ['salt'] }
        expect(response).to have_http_status(:ok)
        expect(json_response['data']['recipes'].map { |r| r['title'] }).to include('Salty Bread')
      end
    end

    context 'when no recipes match the provided ingredients' do
      it 'returns an empty array' do
        get :search, params: { ingredients: ['nonexistent ingredient'] }
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq({
                                      'data' => { 'recipes' => [],
                                                  'pagination' => { 'current_page' => 1, 'total_pages' => 0,
                                                                    'total_count' => 0 } }, 'success' => true
                                    })
      end
    end

    context 'when pagination is provided' do
      it 'returns paginated results' do
        get :search, params: { ingredients: ['all-purpose flour'], page: 2, per_page: 1 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['recipes'].size).to eq(1)
        expect(json_response['data']['pagination']['current_page']).to eq(2)
        expect(json_response['data']['pagination']['total_pages']).to eq(2)
        expect(json_response['data']['pagination']['total_count']).to eq(2)
      end
    end
  end
end
