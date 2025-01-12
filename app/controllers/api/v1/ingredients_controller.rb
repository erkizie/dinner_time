# frozen_string_literal: true

module Api
  module V1
    class IngredientsController < ApplicationController
      def index
        ingredients = Rails.cache.fetch('ingredients', expires_in: 12.hours) do
          Ingredient.select(:id, :name).to_a
        end

        render json: success_response(ingredients.map { |ingredient| { id: ingredient.id, name: ingredient.name } })
      end
    end
  end
end
