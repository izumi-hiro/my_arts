class Public::CustomersController < ApplicationController
  
  def show
    @customer = Customer.find(params[:id])
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customer_path(@customer), notice: "会員情報を変更しました"
    else
      render "edit"
    end
  end
  
  def unsubscribe
  end
  
  def withdraw
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:name, :introduction, :profile_image)
  end
  
end
