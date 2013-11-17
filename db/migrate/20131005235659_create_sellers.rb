class CreateSellers < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.string :name
      t.string :address
      t.string :url
      t.string :link
      t.boolean :enabled, :default => true

      t.timestamps
    end
  end
end
