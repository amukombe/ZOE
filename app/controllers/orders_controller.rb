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
      headers = {
                           
           'Content-Type' => 'text/xml',
           'Content-transfer-encoding' => 'text'
          }
       yoPaymentStatusCode = make_http_post(url, post_xml, headers)
       puts "status code============================================"
           puts yoPaymentStatusCode
         puts "status code============================================"
  #  ******* end of sending request to yo! payments server ******************
      message=getTransactionStatus(yoPaymentStatusCode )


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

  #xml code sending information to yo payments
  def make_http_post(url, data,headers)
    # inherit the required http classes
    require 'net/http'
    http = Net::HTTP.new(url.host, url.port)
      if url.scheme == 'https'
        require 'net/https'
        require 'openssl' # needed for windows environment
        #require 'libxml' 
        #require 'xml/messages'
        http.use_ssl = true
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE   # needed for windows environment
      end

    # send the request
    resp, data = http.post(url.path, data,headers)

    #resp, data = Net::HTTP.post(url,data,header)
    puts 'Response from Yo! Payments ................................'
    puts data    
    #render :xml => data
  
    # Installation http://stackoverflow.com/questions/2915788/libxml-ruby-failed-to-load-at-x86-64
    # install a libxml-ruby version for the respective Ruby version
    parser = LibXML::XML::Parser.file(data)
    doc = parser.parse
    yoPaymentStatusCode=""

    doc.root.each do |node|
       response_nodes = node.children
       response_nodes.each do |response|
     if response.name == "TransactionReference"
      @transaction.transaction_reference = response.content
     elsif response.name == "TransactionStatus"
      @transaction.transaction_status = response.content
                 elsif response.name == "StatusCode"     
                  
                  yoPaymentStatusCode=response.content
    #  yoPaymentStatusCode = yoPaymentStatusCode.to_i
     end
       end
    end
    
    return yoPaymentStatusCode

  end
  #ends here
  #yo uganda status code
  def getTransactionStatus(statusCode)
        returnMessage=""
  if statusCode=="0"
          returnMessage="Transaction was successful"
        elsif statusCode=="1"
    returnMessage="Transaction was successful but pending due to server processing"
  elsif statusCode=="2"
    returnMessage="The transaction failed "
  elsif statusCode=="3"
    returnMessage="The transaction failed but we encountered an error updating the transaction state to mark the transaction as FAILED"
  elsif statusCode=="4"
    returnMessage="The transaction succeeded but we encountered an error updatingthe transaction state to mark the transaction as successful."
  elsif statusCode=="5"
    returnMessage="Network error. Please contact support services"
  elsif statusCode=="6"
    returnMessage="The transaction succeeded. However, because of an internal problem, your balance has not yet been updated to reflect the transaction."
  elsif statusCode=="7"
    returnMessage="Unsupported transaction type transaction failed "
  elsif statusCode=="8"
    returnMessage="Unsupported transaction type ''.processed but there was a problem marking the transaction as FAILED."
  elsif statusCode=="-8"
    returnMessage="Duplicate transaction!. Please vary your submission parameters"
  elsif statusCode=="-4"
    returnMessage="Insufficient funds on Account"
  else
    returnMessage="please try again,check for missing fields, if it fails, check with the administrator"
        end
        
        return returnMessage  
  end
 #ends here
end
