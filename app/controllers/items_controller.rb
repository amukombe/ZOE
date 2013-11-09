class ItemsController < ApplicationController
  # GET /items
  # GET /items.json
  before_filter :confirm_logged_in_admin, :except=>[:index, :show]
  before_filter :confirm_logged_in

  layout 'user'
  def index
      inbox
      unread
      
      @items = Item.paginate :page=>params[:page], :order=>'created_at desc' , :per_page => 10
      @supermarket = session[:branch_id]
      @order_items = Item.find_all_by_branch_id(@supermarket)
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    inbox
    unread

    @item = Item.find(params[:id])
    order_id = @item.order_id
    @order = Order.find_by_id(order_id)
    @line_items = LineItem.find_by_order_id(@order)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    inbox
    unread
    
    @item = Item.new
    @order = Order.find(params[:id])
    @line_items = LineItem.find_by_order_id(@order)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    inbox
    unread

    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    inbox
    unread
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        flash[:notice] = 'Order sucessfully submit'
        format.html { redirect_to :controller=>'orders', :action=>'index' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    inbox
    unread

    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  def status
    @item = Item.find(params[:id])

    if @item.update_attribute(:status, true)
      flash[:notice] = "order successfully submitted"
      redirect_to :controller=>'items', :action=>'show'
    else
      flash[:notice] = "failed to submit order"
    end
  end

  def admin_view
    unread
    @items = Item.paginate :page=>params[:page], :order=>'created_at desc' , :per_page => 10
  end

end
