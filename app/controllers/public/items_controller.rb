class Public::ItemsController < ApplicationController
  # 作品詳細画面、作品一覧画面、タグ検索結果画面はログアウト状態でも閲覧可能
  before_action :authenticate_customer!, except: [:show, :index, :search]
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def index
    # 作品一覧画面では、作品ステータスが公開中かつ作者の会員ステータスが有効の作品が表示される
    @items = Item.where(is_active: 'display', customer: { is_deleted: '_valid'}).includes(:customer, :item_images)
            .order("items.created_at DESC").page(params[:page]).per(40)
    # 作品に紐づく会員ステータスが有効かつ作品ステータスが公開中の作品を表示
    @tag_list = Tag.includes(items: :customer).where(items: {customers: {is_deleted: '_valid'}, is_active: 'display'})
  end

  def show
    @item = Item.find(params[:id])
    # 投稿した本人の会員ステータスが有効であれば
    if @item.customer.is_deleted == '_valid'
      # 公開中作品は誰でも詳細画面にアクセスできる。非公開作品は、投稿した本人のみ詳細画面にアクセスできる
      if @item.is_active == 'display' || (@item.is_active == 'closed' && !current_customer.nil? && @item.customer_id == current_customer.id)
        @item_tags = @item.tags
        @customer = @item.customer
        @item_comment = ItemComment
      else
        # 投稿した本人以外が、非公開作品の詳細画面のURLを入力すると、作品一覧画面に飛ぶ
        redirect_to items_path
      end
    # 退会済み会員に紐づく作品詳細画面のURLを入力すると、作品一覧画面に飛ぶ
    else
      redirect_to items_path
    end
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
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to items_path, notice: "作品を削除しました"
  end

  def search
    @tag = Tag.find(params[:tag_id])
    @tag_list = Tag.joins(items: :customer).where(items: {customers: {is_deleted: '_valid'}, is_active: 'display'})
    @items = @tag.items.where(is_active: 'display', customer: { is_deleted: '_valid'}).includes(:customer, :item_images)
  end

  private

  def item_params
    params.require(:item).permit(:title, :body, :is_active, item_images_images: [])
  end

  def ensure_correct_customer
    @item = Item.find(params[:id])
    unless @item.customer == current_customer
      redirect_to items_path, notice: "アクセス権限がありません"
    end
  end


end
