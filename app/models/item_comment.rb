class ItemComment < ApplicationRecord

  belongs_to :customer
  belongs_to :item

  validates :comment, length: { maximum: 200 }, presence: true

end
