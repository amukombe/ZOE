class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    	t.string :item_name
    	t.integer :quantity
    	t.integer :total_item_price
    	t.integer :total_cost
    	t.integer :cart_id
      t.timestamps
    end
  end
end
