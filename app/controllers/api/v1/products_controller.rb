class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user
  before_action :set_company, only: [:create, :index]
  before_action :authorize_company_admin, only: [:create]

  # GET /api/v1/products
  def index
    @products = @company.products
    render json: @products, status: :ok
  end

  # POST /api/v1/products
  def create
    @product = @company.products.new(product_params)
    
    if @product.save
      render json: { 
        product: @product,
        message: 'Product created successfully' 
      }, status: :created
    else
      render json: { 
        errors: @product.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  private

  def set_company
    @company = current_user.company
    render json: { error: 'Company not found' }, status: :not_found unless @company
  end

  def authorize_company_admin
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.admin?
  end

  def product_params
    params.require(:product).permit(:name)
  end
end
