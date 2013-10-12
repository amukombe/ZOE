class ManageOrders < ActiveRecord::Migration
  def up
  	add_column :orders, :total, :integer
  end

  def down
  	remove_column :orders, :total
  end
end
