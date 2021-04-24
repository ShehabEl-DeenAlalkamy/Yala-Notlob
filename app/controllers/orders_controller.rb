class OrdersController < ApplicationController
  def index
    # @orders = Order.where(user_id: current_user.id)
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
    @Items = OrderMember.where(order: @order)
    @invited = InvitedMember.where(order_id: @order.id).count
    @joind = InvitedMember.where(joind: true).where(order_id: @order.id).count
  end

  def new
    @order = Order.new
    @friends = Friendship.where(user_id: current_user.id)
  end

  def create
    @order = Order.new(order_params)
    @friends = Friendship.where(user_id: current_user.id)
    if @order.save
      redirect_to @order
    else
      render :new
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.status = "Finish"
    @order.save
    respond_to do |format|
      format.js { render partial: "javascripts/orders/finish_order" }
    end
  end
  
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    respond_to do |format|
      format.js { render partial: "javascripts/orders/cancel_order" }
    end
  end

  private
    def order_params
      params.require(:order).permit(:mealtype, :resturant_name, :menu_img, :option).merge(user: current_user)
    end
end