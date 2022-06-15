class Admin::CustomersController < ApplicationController

  def index
    @customers = Customer.all.page(params[:page]).per(20)
  end

  def show
    @customer = Customer.find(params[:id])
    @items = @customer.items.includes(:item_images).order("created_at DESC")
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_customer_path, notice: "更新に成功しました"
    else
      render "edit"
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :profile_image, :is_deleted)
  end

end
