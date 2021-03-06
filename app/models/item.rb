class Item < ApplicationRecord

  belongs_to :customer

  has_many :item_images, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps

  has_many :item_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  accepts_attachments_for :item_images, attachment: :image
  
  with_options presence: true do
    # 画像に限り、上限以上の画像選択時のエラーメッセージを用意する
    validates :item_images, length: { maximum: 8, too_long: "添付は%{count}件以内にしてください" }
    validates :title, length: { maximum: 20 }
    validates :body, length: { maximum: 200 }
  end

  def name
    tags.pluck(:name).join(',')
  end

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_item_tag = Tag.find_or_create_by(name: new)
      self.tags << new_item_tag
    end
  end

  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end

  enum is_active: { display: true, closed: false }

end
