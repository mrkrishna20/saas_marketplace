class ApplicationController < ActionController::API
  private
  
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { error: 'Token required' }, status: :unauthorized unless token
    
    decoded = JsonWebToken.decode(token)
    return render json: { error: 'Invalid token' }, status: :unauthorized unless decoded
    
    @current_user = User.find_by(id: decoded[:user_id])
    return render json: { error: 'User not found' }, status: :unauthorized unless @current_user
    
    @current_user
  end

  def authenticate_user_or_client
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { error: 'Token required' }, status: :unauthorized unless token
    
    decoded = JsonWebToken.decode(token)
    return render json: { error: 'Invalid token' }, status: :unauthorized unless decoded
    
    # Try user authentication first
    if decoded[:user_id]
      @current_user = User.find_by(id: decoded[:user_id])
      return render json: { error: 'User not found' }, status: :unauthorized unless @current_user
    # Then try client authentication
    elsif decoded[:client_id]
      @current_client = Client.find_by(id: decoded[:client_id])
      return render json: { error: 'Client not found' }, status: :unauthorized unless @current_client
    else
      return render json: { error: 'Invalid token format' }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end

  def current_client
    @current_client
  end
end
