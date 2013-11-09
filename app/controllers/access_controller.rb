class AccessController < ApplicationController
  layout 'user'
  def login
    inbox
    unread
  end

  def create
    inbox
    unread

  	authorized_user = User.authenticate(params[:name], params[:password])
    authorized_manager = Manager.authenticate(params[:name], params[:password])
    if authorized_user
		  session[:user_id] = authorized_user.id
	    session[:role_id] = authorized_user.role_id
	    session[:firstname] = authorized_user.firstname
      session[:lastname] = authorized_user.lastname

      session[:role] = authorized_user.role.title
      if session[:role] == "Admin"
		    redirect_to admin_url ,:notice=>'You are welcome to the management committe of mabira shop'
      elsif session[:role] == "Manager"
        redirect_to :controller=>'admin', :action=>'manager',:notice=>'You are welcome to the management committe of mabira shop'
      end
    elsif authorized_manager
      session[:user_id] = authorized_manager.id
      session[:role_id] = authorized_manager.role_id
      session[:seller_id] = authorized_manager.seller_id
      session[:branch_id] = authorized_manager.branch_id
      session[:firstname] = authorized_manager.firstname
      session[:lastname] = authorized_manager.lastname

      session[:role] = authorized_manager.role.title

      redirect_to :controller=>'admin', :action=>'manager',:notice=>'You are welcome to the management committe of mabira shop'
  	else
      flash[:notice]="ivalid username / password combination"
      redirect_to :action=>'login', :notice=>'check your username and password'
  	end
  end

  def menu
    inbox
    unread
  end

  def destroy
    session[:user_id] = nil
    session[:role_id] = nil
    session[:firstname] = nil
    if session[:branch_id]
      session[:branch_id] = nil
    end
    flash[:notice] = "you are logged out"
   redirect_to :controller=>'main', :action=>'index'
  end
end
