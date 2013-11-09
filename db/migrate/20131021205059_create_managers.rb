class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.integer :role_id
      t.integer :seller_id

      t.timestamps
    end
  end
end
