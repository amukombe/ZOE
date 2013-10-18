class AccessController < ApplicationController
  layout 'user'
  def login
  end

  def create
  	authorized_user = User.authenticate(params[:name], params[:password])
    if authorized_user
		session[:user_id] = authorized_user.id
	    session[:role_id] = authorized_user.role_id
	    session[:name] = authorized_user.name
		redirect_to admin_url
  	else
      flash[:notice]="ivalid username / password combination"
      redirect_to :action=>'login', :notice=>'check your username and password'
  	end
  end

  def menu
  end

  def destroy
  end
end
