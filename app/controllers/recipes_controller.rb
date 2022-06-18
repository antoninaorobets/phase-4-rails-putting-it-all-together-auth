class RecipesController < ApplicationController
    before_action :authorize

    def index
        recipes = Recipe.all
        render json: recipes, status: :ok
    end

    def create
        user = User.find(session[:user_id])
        recepe = user.recipes.create!(recipe_params)
        render json: recepe, status: :created
    rescue ActiveRecord::RecordInvalid => invalid
        render json: {errors: ["invalid.record.errors.full_messages"]}, status: :unprocessable_entity 

    end

    private

    def authorize
       return render json: {errors: ["not authorized"]}, status: :unauthorized unless session.include? :user_id
    end
    def recipe_params
        params.permit(:title, :minutes_to_complete, :instructions)
    end
  
end
