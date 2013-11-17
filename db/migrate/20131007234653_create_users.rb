class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.integer :role_id
      t.string :firstname
      t.string :lastname
      t.string :phone_no
      t.string :address

      t.timestamps
    end
  end
end
