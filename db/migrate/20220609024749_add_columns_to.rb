class AddColumnsTo < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :name, :string, null: false
    add_column :customers, :is_deleted, :boolean, default: false, null: false
  end
end
