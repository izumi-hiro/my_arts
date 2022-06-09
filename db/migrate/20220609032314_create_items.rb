class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      
      t.integer :customer_id, null: false
      t.integer :tag_id, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :is_active, default: true, null: false
      
      t.timestamps
    end
  end
end
