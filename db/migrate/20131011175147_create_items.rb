class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    t.integer  :order_id
    t.integer  :seller_id
    t.boolean  :status,     :default => false
    t.integer  :branch_id
    t.timestamps
    end
  end
end
