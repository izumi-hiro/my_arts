class ItemImage < ApplicationRecord
  
  belongs_to :item
  
  attachment :image
  
end
