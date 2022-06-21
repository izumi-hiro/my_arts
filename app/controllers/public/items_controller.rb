class Public::ItemsController < ApplicationController
  before_action :authenticate_customer!, except: [:show, :index]
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def index
    @items = Item.where(is_active: true, customer: { is_deleted: false}).includes(:customer, :item_images).order("items.created_at DESC").page(params[:page]).per(12)
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
    tag_list = params[:item][:name].split(',')
    if @item.save
      @item.save_tag(tag_list)
      redirect_to items_path, notice: "作品を投稿しました"
    else
      render "new"
    end
  end

  def edit
    @item = Item.find(params[:id])
    #@tag_list = @item.tags.pluck(:name).join(",")
  end

  def update
    @item = Item.find(params[:id])
    @item.customer_id = current_customer.id
    tag_list = params[:item][:name].split(',')
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
    @tag = Tag.find(params[:tag_id])
    @tag_list = Tag.all
    @items = @tag.items.where(is_active: true)
  end

  private

  def item_params
    params.require(:item).permit(:title, :body, :is_active, item_images_images: [])
  end
  
  def ensure_correct_customer
    @item = Item.find(params[:id])
    unless @item.customer == current_customer
      redirect_to items_path
    end
  end

end
