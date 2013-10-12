class Seller < ActiveRecord::Base
  has_many :products
  attr_accessible :address, :name, :url, :link
  validates :name, :presence=>true, :uniqueness=>true
  validates :address,:url, :presence=>true

end
