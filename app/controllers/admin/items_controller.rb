class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @items = Item.all.includes(:item_images).order("created_at DESC").page(params[:page]).per(10)
  end

  def show
    @item = Item.find(params[:id])
    @item_tags = @item.tags
    @customer = @item.customer
    @item_comment = ItemComment
  end

  def edit
    @item = Item.find(params[:id])
    @item_tags = @item.tags
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_item_path, notice: "更新に成功しました"
    else
      render "edit"
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :body, :is_active, item_images_images: [])
  end

end


