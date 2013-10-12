class StoreController < ApplicationController
  layout 'admin'
  skip_before_filter :authorize
  def index
  	#@seller = Seller.find(params[:seller_id])
  	#@products = Product.all.where(:seller_id=>@seller.id)

  	begin
    @catalog = Seller.find(params[:seller_id])
    @seller = current_seller
    seller = Seller.find(params[:seller_id])
    @products = Product.order.where(:seller_id=>seller.id)
  	 
  	@cart = current_cart
  	rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      #flash[:notice] = "Invalid seller"
      redirect_to :controller=>'main',:action=>'index'
      else
      	respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @cart }
      end
  	#@seller = current_seller
  	end
  end
end
