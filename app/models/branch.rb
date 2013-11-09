class Branch < ActiveRecord::Base
   belongs_to :seller
   belongs_to :item
   has_many :managers
   has_many :orders

   attr_accessible :seller_id, :address, :branch_name

   validates :seller_id, :address, :branch_name, :presence=>true
end
