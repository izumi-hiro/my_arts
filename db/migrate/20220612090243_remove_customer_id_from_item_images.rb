class RemoveCustomerIdFromItemImages < ActiveRecord::Migration[6.1]
  def change
    remove_column :item_images, :customer_id, :integer
  end
end
