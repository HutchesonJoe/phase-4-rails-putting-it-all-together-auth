class SessionsController < ApplicationController
  skip_before_action :authorized, only: :create
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: {errors: ["Invalid username or password"]}, status: :unauthorized
    end
  end

  def destroy
    session.delete :user_id
    head :no_content
  end

  private

  def render_not_found_response(not_found)
    render json: { errors: not_found }, status: 401
  end

  def render_record_invalid_response(invalid) 
    render json: { errors: invalid.record.errors.full_messages }, status: 422
  end
  
end
