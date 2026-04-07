class Api::V1::SessionsController < ApplicationController

  def login
    @user = User.find_by(email: params[:email])
    
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode({ user_id: @user.id })
      render json: { 
        user: @user,
        token: token 
      }, status: :ok
    else
      render json: { 
        error: 'Invalid email or password' 
      }, status: :unauthorized
    end
  end

  def logout
    # For JWT, we don't need to do anything server-side
    # Client should discard the token
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
