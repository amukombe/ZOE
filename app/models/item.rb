class Item < ActiveRecord::Base
  attr_accessible :order_id, :seller_id, :branch_id
  #validates :order_id, :uniqueness=>true
  has_many :orders
  has_many :branches
end
