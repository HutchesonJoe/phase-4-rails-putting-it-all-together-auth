class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
   
    recipes = Recipe.all
    render json: recipes, status: :created
  end

  def create
  
    recipe = @current_user.recipes.create!(recipe_params)
    render json: recipe, status: :created
 
  end

  private
  
  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

  def render_record_invalid_response(invalid)
    
    render json: { errors: invalid.record.errors.full_messages }, status: 422
  end

  def render_not_found_response(not_found)
    byebug
    render json: { errors: not_found }, status: 401
  end

end
