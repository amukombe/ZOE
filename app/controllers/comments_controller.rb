class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  before_filter :confirm_logged_in_admin, :except => [:new, :create]
  layout 'user'

  def index
    inbox
    unread

    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    inbox
    unread

    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    inbox
    unread

    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    inbox
    unread

    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    inbox
    unread

    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:notice]= 'Thank you for using mabira'
        format.html { redirect_to :controller=>'main', :action=>'contact', :notice=> 'Comment was successfully created.' }
        #format.json { render json: @comment, status: :created, location: @comment }
      else
        flash[:notice]='Failed to create comment'
        format.html { redirect_to :controller=>'main', :action=> 'contact' }
        #format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    inbox
    unread

    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    inbox
    unread
    
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
