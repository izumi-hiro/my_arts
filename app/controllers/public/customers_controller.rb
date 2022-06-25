class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!, except: [:show]
  before_action :ensure_correct_customer, only: [:edit, :update, :withdraw]

  def show
    @customer = Customer.find(params[:id])
    @items = @customer.items.includes(:item_images).order("created_at DESC")
    
    favorites = Favorite.where(customer_id: @customer.id).pluck(:item_id)
    #会員ステータスがtrue（退会）の作者をdeleted_customer_idsに代入。
    deleted_customer_ids = Customer.where(is_deleted: true)
    #お気に入り一覧の作品は、いいねをした作品かつ作品の公開ステータスがtrueである。ただし、deleted_customer_idsに該当する作品は除外。
    @favorite_list = Item.where(id: favorites, is_active: true).where.not(customer_id: deleted_customer_ids)
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
    @customer = current_customer
  end

  def withdraw
    @customer = current_customer
    @customer.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "退会に成功しました"
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_customer
    @customer = Customer.find(params[:id])
    unless @customer == current_customer
      redirect_to items_path, notice: "アクセス権限がありません"
    end
  end

end
