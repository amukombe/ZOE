class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
    	t.integer :seller_id
    	t.string :branch_name
    	t.string :address
      t.timestamps
    end
  end
end
