class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.text :address
      t.string :email
      t.string :pay_type
      t.string :phone_no
      t.decimal :total
      t.boolean :status,:default => false
      t.boolean :delivery
      t.integer :branch_id
      t.time :delivery_time

      t.timestamps
    end
  end
end
