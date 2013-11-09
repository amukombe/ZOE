class MainController < ApplicationController
  layout 'admin'

  def index
  	unread
  	inbox
  	
  	@sellers = Seller.all
  	@products = Product.all
  	@cart = current_cart
  	#@seller = current_seller
  end
end
