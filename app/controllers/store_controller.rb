class StoreController < ApplicationController
  layout 'admin'
  
  def index
  	unread
    inbox

  	begin
    @catalog = Seller.find(params[:seller_id])
    @seller = current_seller
    seller = Seller.find(params[:seller_id])
    @products = Product.order.where(:seller_id=>seller.id).paginate :page=>params[:page], :order=>'created_at desc' , :per_page => 15
  	 
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

  def advanced_search
    @products = Product.where("title LIKE ? ", "%#{params[:search]}%")
  end

  def self.search(search)
    return scoped unless search.present?
      where(['title LIKE ?', "%#{search}%"])
  end
  
end
