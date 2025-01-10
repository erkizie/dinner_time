# frozen_string_literal: true

module Api
  module V1
    class RecipesController < ApplicationController
      def search
        recipes = RecipesQuery.new(ingredients: params[:ingredients]).call
        render json: success_response(recipes.map { |recipe| Api::V1::RecipeSerializer.new(recipe).run })
      rescue StandardError => e
        render json: failure_response(["An unexpected error occurred: #{e.message}"])
      end
    end
  end
end
