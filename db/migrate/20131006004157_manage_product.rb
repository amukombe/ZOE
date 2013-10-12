class ManageProduct < ActiveRecord::Migration
  def up
  	add_column :products, :seller_id, :integer
  	add_column :sellers, :link, :string
  end

  def down
  	remove_column :sellers, :link
  	remove_column :products, :seller_id
  end
end
