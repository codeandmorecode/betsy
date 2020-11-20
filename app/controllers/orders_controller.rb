class OrdersController < ApplicationController
  before_action :find_order, except: [:index, :new, :create, :status_filter]
  skip_before_action :require_login, except: [:index]
  skip_before_action :require_login

  def index
    @orders = Order.all
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      flash[:success] = "First item added to cart. Welcome to Stellar."
      redirect_to order_path(@order.id)
    else
      flash.now[:error] = "Error: shopping cart was not created."
      @order.errors.each { |name, message| flash.now[:error] << "#{name.capitalize.to_s.gsub('_', ' ')} #{message}." }
      flash.now[:error] << "Please try again."
      render :new, status: :bad_request
    end
    return
  end

  def show
  end

  def edit
  end

  def update
    if @order.complete_date
      flash[:error] = "Your order has already been submitted for fulfillment. Please contact customer service for assistance."
      redirect_back fallback_location: order_path(@order.id)
    end

    if @order.update(order_params)
      flash[:success] = "#{@order.complete_date ? "Order" : "Shopping cart" } successfully updated."
      redirect_to order_path(@order.id)
    else
      flash.now[:error] = "Error: #{@order.complete_date ? "order" : "shopping cart" } did not update."
      @order.errors.each { |name, message| flash.now[:error] << "#{name.capitalize.to_s.gsub('_', ' ')} #{message}." }
      flash.now[:error] << "Please try again."
      render :edit, status: :bad_request
    end
    return
  end

  def destroy
    ##can do this in model with dependent: destroy
    # @order.order_items.destroy_all

    if @order.destroy
      flash[:success] = "#{@order.complete_date ? "Order successfully deleted" : "Shopping cart successfully cancelled" }."
      redirect_back fallback_location: orders_path
    else
      flash[:error] = "Error: #{@order.complete_date ? "order was not deleted" : "shopping cart was not cancelled" }. Please try again."
      redirect_back fallback_location: order_path(@order.id), status: :internal_server_error
    end
    return
  end

  def complete
    if @order.update(status: "complete", complete_date: Time.now)
      flash[:success] = "Your order has successfully been submitted."
      redirect_back fallback_location: root_path
    else
      flash[:error] = "Error: Order was not completed. Please try again."
      redirect_back fallback_location: order_path(@order.id), status: :bad_request
    end
    return
  end

  def cancel
    if @order.update(status: "cancelled")
      flash[:success] = "Order ##{@order.id} successfully cancelled."
    else
      flash[:error] = "Error. Order ##{@order.id} was not cancelled. Please try again."
    end
    redirect_back fallback_location: order_path(@order.id)
    return
  end

  def status_filter
    status = params[:order][:status]
    #TODO: write filter_orders model method
    @orders = Order.filter_orders(status)
    #TODO: DOES THIS NEED A REDIRECTION?
    return
  end

  ###TODO: COMPLETE CHECKOUT METHOD
  def checkout
    unless @order.user.is_auth
      #ask user if they would like to log in or proceed as guest
    end
  end

  private

  def order_params
    return require(:order).permit(:user_id, :order_item_id, :shipping_info_id, :billing_info_id, :status, :submit_date, :complete_date)
  end

  def find_order
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      flash.now[:error] = "Order not found."
      render_404
      return
    end
  end
end