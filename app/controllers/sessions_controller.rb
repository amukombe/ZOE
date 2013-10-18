class SessionsController < ApplicationController
  layout 'user'
  before_filter :confirm_logged_in, :except=>[:new, :create]

  def index
    menu
    render 'menu'
  end

  def menu
     redirect_to :controller=>'admin', :action=>'index'
  end

  def login
  end

  def new
    
  end

  def create
  	authorized_user = User.authenticate(params[:name], params[:password])
    if authorized_user
  		session[:user_id] = authorized_user.id
      session[:role_id] = authorized_user.role_id
      session[:name] = authorized_user.name
  		redirect_to admin_url
  	else
      flash[:notice]="Invalid Username / Password combination"
  		redirect_to :controller=>'sessions',:action=>'new'
  	end
  end

  def destroy
  	session[:user_id] = nil
    session[:role_id] = nil
    session[:name] = nil

    flash[:notice] = "you are logged out"
	 redirect_to :controller=>'main', :action=>'index'
  end
end
