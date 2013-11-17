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

  def aboutus
    unread
    inbox
    
    @sellers = Seller.all
    @products = Product.all
    @cart = current_cart
    #@seller = current_seller
  end

  def contact
    unread
    inbox
    
    @sellers = Seller.all
    @products = Product.all
    @com  = Comment.order('comments.created_at')
    @cart = current_cart
    #@seller = current_seller
    @comments = Comment.new

  end

  def service
    unread
    inbox
    
    @sellers = Seller.all
    @products = Product.all
    @cart = current_cart
    #@seller = current_seller
  end

  def news
    unread
    inbox
    
    @sellers = Seller.all
    @products = Product.all
    @cart = current_cart
    #@seller = current_seller
    @news = News.paginate :page=>params[:page], :order=>'created_at desc' , :per_page => 12
  end

  def adverts
    unread
    inbox
    
    @sellers = Seller.all
    @products = Product.all
    @cart = current_cart
    #@seller = current_seller
    @adverts = Advert.paginate :page=>params[:page], :order=>'created_at desc' , :per_page => 12
  end
end
