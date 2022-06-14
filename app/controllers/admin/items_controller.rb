class Admin::ItemsController < ApplicationController
  
  def index
  end
  
  def show
    @item = Item.find(params[:id])
    @item_tags = @item.tags
    @customer = @item.customer
    @item_comment = ItemComment
  end
  
  def edit
  end
  
  def update
  end
  
  private

  def item_params
    params.require(:item).permit(:title, :body, :is_active, item_images_images: [])
  end
  
end


