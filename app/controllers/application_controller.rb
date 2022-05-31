class ApplicationController < ActionController::API
  include ActionController::Cookies
  before_action :authorized

  def authorized
    @current_user = User.find_by(id: session[:user_id])
    return render json: { errors: ["Not Authorized"]}, status: :unauthorized unless @current_user 
  end
 
end
