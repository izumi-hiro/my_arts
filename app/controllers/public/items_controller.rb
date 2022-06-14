class Public::ItemsController < ApplicationController

  def index
    @items = Item.where(is_active: true).includes(:item_images).order("created_at DESC")
    @tag_list = Tag.all
  end

  def show
    @item = Item.find(params[:id])
    @item_tags = @item.tags
    @customer = @item.customer
    @item_comment = ItemComment
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.customer_id = current_customer.id
    tag_list = params[:item][:name].split(nil)
    if @item.save!
      @item.save_tag(tag_list)
      redirect_to items_path, notice: "作品を投稿しました"
    else
      redirect_to root_path
    end
  end

  def edit
    @item = Item.find(params[:id])
    @tag_list = @item.tags.pluck(:name).join(",")
  end

  def update
    @item = Item.find(params[:id])
    @item.customer_id = current_customer.id
    tag_list = params[:item][:name].split(nil)
    if @item.update(item_params)
      @item.save_tag(tag_list)
      redirect_to item_path(@item), notice: "作品情報を変更しました"
    else
      render "edit"
    end
  end

  def destroy
  end

  def search
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @items = @tag.items.all
  end

  private

  def item_params
    params.require(:item).permit(:title, :body, item_images_images: [])
  end

end
