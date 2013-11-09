class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  belongs_to :item
  belongs_to :branch
  
  attr_accessible :address, :email, :name, :pay_type, :bought, :total, :phone_no, :delivery, :branch_id, :delivery_time
  
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9._]+\.[A-Z]{2,4}$/i

  PAYMENT_TYPES = [ "MTN Mobile Money", "WARID Pesa" , "M-Sente" , "AIRTEL Money" ]
  validates :name, :delivery, :delivery_time, :pay_type, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES
  validates :email,:length=>{:maximum=>100}, :format=>EMAIL_REGEX,:confirmation=>true

  def add_line_items_from_cart(cart)
	cart.line_items.each do |item|
		item.cart_id = nil
		line_items << item
	end
   end
end
