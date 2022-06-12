class TagMap < ApplicationRecord
  
  belongs_to :item
  belongs_to :tag
  
  validates :_id, presence: true
  validates :tag_id, presence: true
  
end
