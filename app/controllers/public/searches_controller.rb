class Public::SearchesController < ApplicationController
  
  def search
    @model = params["model"]
    @content = params["content"]
    @method = params["method"]
    @records = search_for(@model, @content, @method)
  end
  
  private
  
  def search_for(model, content, method)
    if model == 'customer'
      if method == 'perfect'
        # 会員ステータスがfalse(有効)の会員に絞る
        Customer.where(name: content, is_deleted: false)
      else
        Customer.where('name LIKE ?', '%'+content+'%').where(is_deleted: false)
      end
    elsif model == 'item'
      if method == 'perfect'
        # 作品ステータスがtrue(公開)かつ作者の会員ステータスがfalse(有効)の作品に絞る。includesで他テーブルの情報を取得
        Item.where(title: content, is_active: true, customer: { is_deleted: false}).includes(:customer, :item_images)
      else
        Item.where('title LIKE ?', '%'+content+'%').where(is_active: true, customer: { is_deleted: false}).includes(:customer, :item_images)
      end
    end
  end
  
end
