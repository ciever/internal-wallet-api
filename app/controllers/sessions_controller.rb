class SessionsController < ApplicationController
	def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password]) # uses bcrypt's authenticate method
      session[:user_id] = user.id # store user ID in session
      render json: { message: 'Signed in successfully.' }, status: :ok
    else
      render json: { error: 'Invalid email or password.' }, status: :unauthorized
    end
  end

  def destroy
    session[:user_id] = nil # log out by clearing the session
    render json: { message: 'Signed out successfully.' }, status: :ok
  end
end
