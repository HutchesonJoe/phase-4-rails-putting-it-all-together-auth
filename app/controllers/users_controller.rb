class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create, :index]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  def index
    users = User.all 
    render json: users 
  end

  def create
    user = User.create!(user_params)
    session[:user_id] = user.id
    render json: user, status: :created
  end

  def show
    user = User.find(session[:user_id])
    render json: user
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :image_url, :bio)
  end

  def render_record_invalid_response(invalid) 
    
    render json: { errors: invalid.record.errors.full_messages }, status: 422
  end
  
  def render_not_found_response(not_found)
    byebug
    render json: { errors: not_found }, status: 401
  end
end
