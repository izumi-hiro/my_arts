class Public::RelationshipsController < ApplicationController

  def create
    customer = Customer.find(params[:customer_id])
    current_customer.follow(customer)
		redirect_to request.referer
  end

  def destroy
    customer = Customer.find(params[:customer_id])
    current_customer.unfollow(customer)
		redirect_to request.referer
  end

  def followings
    customer = Customer.find(params[:customer_id])
		@customers = customer.followings.where.not(is_deleted: true)
  end

  def followers
    customer = Customer.where.not(is_deleted: true).find(params[:customer_id])
		@customers = customer.followers.where.not(is_deleted: true)
  end

end
