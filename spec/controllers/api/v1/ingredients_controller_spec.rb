# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Ingredients', type: :request do
  describe 'GET /api/v1/ingredients' do
    before do
      create(:ingredient, name: 'Salt')
      create(:ingredient, name: 'Sugar')
      create(:ingredient, name: 'Flour')
    end

    it 'returns all ingredients' do
      get '/api/v1/ingredients'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['success']).to be true
      expect(json_response['data']).to include(
        { 'id' => Ingredient.find_by(name: 'Salt').id, 'name' => 'Salt' },
        { 'id' => Ingredient.find_by(name: 'Sugar').id, 'name' => 'Sugar' },
        { 'id' => Ingredient.find_by(name: 'Flour').id, 'name' => 'Flour' }
      )
    end

    it 'caches the response' do
      expect(Rails.cache).to receive(:fetch).with('ingredients', expires_in: 12.hours).and_call_original
      get '/api/v1/ingredients'
    end
  end
end
