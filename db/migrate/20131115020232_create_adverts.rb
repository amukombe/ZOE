class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
    	t.string :title
    	t.string :owner
    	t.text :description
    	t.string :image_url
      t.timestamps
    end
  end
end
