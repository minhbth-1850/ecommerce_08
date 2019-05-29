module Admin
  class OrdersController < ApplicationController
    before_action :logged_in_user, :logged_as_admin
    before_action :load_order, only: %i(edit update)

    def index
      @orders = Order.latest.paginate(page: params[:page],
        per_page: Settings.cart.per_page)
    end

    def edit; end

    def update
      if @order.update_attributes order_params
        flash[:success] = t "flash.profile_update"
        send_user_email
        redirect_to :admin_orders
      else
        render :edit
      end
    end

    private

    def load_order
      @order = Order.find_by id: params[:id]
      return if @order

      flash[:danger] = t "flash.nil_object", name: "order"
      redirect_to :admin_orders
    end

    def order_params
      params.require(:order).permit :state
    end

    def send_user_email
      UserMailer.order_email(@order.user, @order).deliver_now if @order.user
    end
  end
end
