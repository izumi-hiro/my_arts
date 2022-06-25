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
    @customer = Customer.find(params[:customer_id])
    # 会員ステータスが有効の会員のフォロー一覧のみ、アクセスできる
    if @customer.is_deleted == '_valid'
      customer = Customer.find(params[:customer_id])
      # フォロー一覧から、退会（論理削除）した会員を除外する
      @customers = customer.followings.where.not(is_deleted: true)
    else
      redirect_to items_path
    end
  end

  def followers
    @customer = Customer.find(params[:customer_id])
    # 会員ステータスが有効の会員のフォロワー一覧のみ、アクセスできる
    if @customer.is_deleted == '_valid'
      customer = Customer.find(params[:customer_id])
      # フォロー一覧から、退会（論理削除）した会員を除外する
  		@customers = customer.followers.where.not(is_deleted: true)
    else
      redirect_to items_path
    end
  end

end
