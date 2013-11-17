class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.integer :role_id
      t.integer :seller_id
      t.integer :branch_id
      t.string  :firstname
      t.string  :lastname
      t.string  :email
      t.string  :phone_no
      t.string  :address

      t.timestamps
    end
  end
end
