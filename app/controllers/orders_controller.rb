class OrdersController < ApplicationController
  before_filter :confirm_logged_in, :except => [:new, :create]
  # GET /orders
  # GET /orders.json
  layout 'admin'

  def index
    unread

    @orders = Order.paginate :page=>params[:page], :order=>'created_at desc' , :per_page => 10
    #@orders = Order.all
    @cart = current_cart
    #@line_items = LineItem.find(params[:order_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    unread

    @order = Order.find(params[:id])
    @cart = current_cart
    @line_items = LineItem.find_by_order_id(@order)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    unread

    @cart = current_cart
    if @cart.line_items.empty?
      flash[:notice] = "Your cart is empty"
      redirect_to(:controller=>'store', :action=>'index')
      return
    end

    @order = Order.new
    @cart = current_cart
    @line_item = LineItem.find_by_cart_id(@cart)

    #getting branches
    supermarket = @line_item.product.seller.id
    @branches = Branch.find_all_by_seller_id(supermarket)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    unread

    @order = Order.find(params[:id])
    @cart = current_cart
  end

  # POST /orders
  # POST /orders.json
  def create
    unread

    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to :controller=>'main', :action=>'index', :notice => "Your cart is empty"
      return
    end


    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)

    @line_item = LineItem.find_by_cart_id(@cart)
    #getting branches
    supermarket = @line_item.product.seller.id
    @branches = Branch.find_all_by_seller_id(supermarket)

    #  ******* sending request to yo! payments server ******************
  # call the http post method
      url = URI.parse('https://41.220.12.206/services/yopaymentsdev/task.php')
      
        post_xml ="<?xml version='1.0' encoding='UTF-8'?><AutoCreate><Request><APIUsername>90005409835</APIUsername><APIPassword>1118051980</APIPassword>"+
    "<Method>acdepositfunds</Method><NonBlocking>FALSE</NonBlocking><Amount>#{@order.total}</Amount>"+
        "<Account>#{@order.phone_no}</Account>"+
        # "<Account>#{@transaction.transactor_pin_no}</Account>"+
    "<AccountProviderCode>MTN_UGANDA</AccountProviderCode><Narrative> Complete order from #{@order.branch_id}</Narrative>"+
    "</Request></AutoCreate>"
    make_http_request(url, post_xml)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        Notifier.order_received(@order).deliver
        flash[:notice] = 'Thank you for your order.' 
        format.html { redirect_to(:controller=>'main', :action=>'index') }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def make_http_request(url, post_xml)
    require 'net/http'
    require 'openssl' # needed for windows environment
    #require 'xml/libxml' 
    require 'hpricot'
    require 'open-uri'
    array_order = []
    http = Net::HTTP.new(url.host, url.port)
       if url.scheme == 'https'
        require 'net/https'
        http.use_ssl = true
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE   # needed for windows environment
      end
    post_xml = http.post(url.path, post_xml)
    puts post_xml

    #parser = XML::Parser.new
    #parser.string = xml_string
    doc = Hpricot.XML("#{url}, #{post_xml}")
    array_order

  end
  # PUT /orders/1
  # PUT /orders/1.json
  def update
    unread

    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  def status
    unread
    
    @order = Order.find(params[:id])

    if @order.update_attribute(:status, true)
      flash[:notice] = "order successfully submitted"
      redirect_to :controller=>'items', :action=>'new', :id=>@order
    else
      flash[:notice] = "failed to submit order"
    end
  end
  
end
