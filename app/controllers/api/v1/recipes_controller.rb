# frozen_string_literal: true

module Api
  module V1
    class RecipesController < ApplicationController
      def search
        recipes = RecipesQuery.new(
          ingredients: params[:ingredients] || [],
          page: params[:page] || 1,
          per_page: params[:per_page] || 10
        ).call

        render json: success_response(
          recipes: recipes.map { |recipe| Api::V1::RecipeSerializer.new(recipe).run },
          pagination: {
            current_page: recipes.current_page,
            total_pages: recipes.total_pages,
            total_count: recipes.total_count
          }
        )
      rescue StandardError => e
        render json: failure_response(["An unexpected error occurred: #{e.message}"])
      end
    end
  end
end
