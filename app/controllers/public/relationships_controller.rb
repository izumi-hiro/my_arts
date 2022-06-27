class Public::RelationshipsController < ApplicationController

  def create
    # 非同期のためcustomerを@customerに変更。2行目(customer)も同様
    @customer = Customer.find(params[:customer_id])
    current_customer.follow(@customer)
		# 非同期のため、redirect_toを削除
  end

  def destroy
    # 非同期のためcustomerを@customerに変更。2行目(customer)も同様
    @customer = Customer.find(params[:customer_id])
    current_customer.unfollow(@customer)
		# 非同期のため、redirect_toを削除
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
