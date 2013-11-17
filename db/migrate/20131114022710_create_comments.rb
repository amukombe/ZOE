class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.text :description
    	t.string :name
    	t.string :email
      t.timestamps
    end
  end
end
