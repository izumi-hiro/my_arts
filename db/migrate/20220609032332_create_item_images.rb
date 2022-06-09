class CreateItemImages < ActiveRecord::Migration[6.1]
  def change
    create_table :item_images do |t|
      
      t.integer :customer_id, null: false
      t.integer :item_id, null: false
      t.string :image_id, null: false
      
      t.timestamps
    end
  end
end
