class AdvertsController < ApplicationController
  # GET /adverts
  # GET /adverts.json
  before_filter :confirm_logged_in_admin
  layout 'user'

  def index
    inbox
    unread

    @adverts = Advert.paginate :page=>params[:page], :order=>'created_at desc' , :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adverts }
    end
  end

  # GET /adverts/1
  # GET /adverts/1.json
  def show
    inbox
    unread

    @advert = Advert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @advert }
    end
  end

  # GET /adverts/new
  # GET /adverts/new.json
  def new
    inbox
    unread

    @advert = Advert.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @advert }
    end
  end

  # GET /adverts/1/edit
  def edit
    inbox
    unread

    @advert = Advert.find(params[:id])
  end

  # POST /adverts
  # POST /adverts.json
  def create
    inbox
    unread

    @advert = Advert.new(params[:advert])

    respond_to do |format|
      if @advert.save
        format.html { redirect_to @advert, notice: 'Advert was successfully created.' }
        format.json { render json: @advert, status: :created, location: @advert }
      else
        format.html { render action: "new" }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adverts/1
  # PUT /adverts/1.json
  def update
    inbox
    unread

    @advert = Advert.find(params[:id])

    respond_to do |format|
      if @advert.update_attributes(params[:advert])
        format.html { redirect_to @advert, notice: 'Advert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adverts/1
  # DELETE /adverts/1.json
  def destroy
    inbox
    unread
    
    @advert = Advert.find(params[:id])
    @advert.destroy

    respond_to do |format|
      format.html { redirect_to adverts_url }
      format.json { head :no_content }
    end
  end
end
