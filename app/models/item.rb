class Item < ApplicationRecord
    
  belongs_to :customer
  
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  
  has_many :item_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
    
end
