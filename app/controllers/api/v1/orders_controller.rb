class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user_or_client

  # GET /api/v1/orders
  def index
    if @current_user
      # Users can see orders for their company
      @orders = Order.where(company: @current_user.company).includes(:client, :product)
    elsif @current_client
      # Clients can see their own orders
      @orders = Order.where(client: @current_client).includes(:product, :company)
    end
    
    render json: @orders, status: :ok
  end


  # POST /api/v1/orders
  def create
    product = Product.find_by(id: order_params[:product_id])
    return render json: { error: 'Product not found' }, status: :not_found unless product

    @order = Order.new(
      client: @current_client,
      product: product,
      company: product.company,
      amount: product.price || 0,
      status: 'pending'
    )

    if @order.save
      render json: { 
        order: @order,
        message: 'Order created successfully' 
      }, status: :created
    else
      render json: { 
        errors: @order.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end


  private


  def order_params
    params.require(:order).permit(:product_id)
  end
end
