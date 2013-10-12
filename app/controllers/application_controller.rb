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
		unless User.find_by_id(session[:user_id])
		flash[:notice] = "Please log in"
		redirect_to :controller=>'sessions', :action=>'new'
		end
	end
end
