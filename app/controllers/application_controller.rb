class ApplicationController < ActionController::Base
  #before_filter :authorize
  protect_from_forgery

  protected
	def current_cart
		Cart.find(session[:cart_id])
		rescue ActiveRecord::RecordNotFound
		cart = Cart.create
		session[:cart_id] = cart.id
		cart
	end
	def current_seller
		Seller.find(session[:seller_id])
		rescue ActiveRecord::RecordNotFound
		seller = Seller.create
		session[:seller_id] = seller.id
		seller
	end

	def confirm_logged_in
		unless session[:user_id]
		flash[:notice] = "Please you must login"
		redirect_to :controller=>'access', :action=>'login', :notice=>'You do not permissions to access this page until you login in'
		end
	end
	def confirm_logged_in_admin
		unless User.find_by_id(session[:user_id]) && session[:role] == "Admin"
		flash[:notice] = "You do not have enough rights to perform this action"
		redirect_to :controller=>'access', :action=>'login',:notice=>'You do not permissions to access this page until you login in'
		end
	end
	def inbox
		@items = Item.all
	  	branch = false
	  	@total_orders = Item.find_all_by_status(branch)
	end
	def unread
		@total_orders = Order.count
	  	status = false
	  	@unread = Order.find_all_by_status(status)
	end
	
end
