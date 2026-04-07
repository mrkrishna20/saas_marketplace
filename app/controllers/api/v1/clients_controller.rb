class Api::V1::ClientsController < ApplicationController
  # POST /api/v1/clients/register
  def register
    @client = Client.new(client_params)
    
    if @client.save
      render json: { 
        client: @client,
        message: 'Global client registered successfully' 
      }, status: :created
    else
      render json: { 
        errors: @client.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/clients/login
  def login
    @client = Client.find_by(email: params[:email])
    
    if @client&.authenticate(params[:password])
      token = JsonWebToken.encode({ client_id: @client.id })
      render json: { 
        client: @client,
        token: token 
      }, status: :ok
    else
      render json: { 
        error: 'Invalid email or password' 
      }, status: :unauthorized
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :email, :phone, :password, :password_confirmation)
  end
end
