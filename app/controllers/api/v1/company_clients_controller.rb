class Api::V1::CompanyClientsController < ApplicationController
  before_action :authenticate_user
  before_action :set_company, only: [:create, :index]
  before_action :authorize_company_admin, only: [:create]

  # GET /api/v1/company_clients
  def index
    @company_clients = @company.company_clients
    render json: @company_clients, status: :ok
  end

  # POST /api/v1/company_clients
  def create
    client = find_existing_client
    @company_client = @company.company_clients.new(
      client: client,
      name: company_client_params[:name],
      email: company_client_params[:email],
      phone: company_client_params[:phone]
    )
    
    if @company_client.save
      render json: { 
        company_client: @company_client,
        client: client,
        message: client.present? ? 'Existing client associated and company client created successfully' : 'Company client created successfully'
      }, status: :created
    else
      render json: { 
        errors: @company_client.errors.full_messages 
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { 
      error: e.message 
    }, status: :unprocessable_entity
  end

  private

  def set_company
    @company = current_user.company
    render json: { error: 'Company not found' }, status: :not_found unless @company
  end

  def authorize_company_admin
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.admin?
  end

  def company_client_params
    params.require(:company_client).permit(:name, :email, :phone)
  end

  def find_existing_client
    if company_client_params[:email].present? || company_client_params[:phone].present?
      Client.find_by('email = ? OR phone = ?', 
                    company_client_params[:email], 
                    company_client_params[:phone])
    end
  end
end
