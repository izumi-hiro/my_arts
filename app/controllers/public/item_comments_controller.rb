class Public::ItemCommentsController < ApplicationController

  def create
    @item = Item.find(params[:item_id])
    @item_comment = ItemComment.new(item_comment_params)
    @item_comment.item_id = @item.id
    @item_comment.customer_id = current_customer.id
    if @item_comment.save
    else
      @error = "200文字以内で入力してください"
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    @item_comment = @item.item_comments.find(params[:id])
    @item_comment.destroy
  end

  private

  def item_comment_params
    params.require(:item_comment).permit(:comment)
  end
end
