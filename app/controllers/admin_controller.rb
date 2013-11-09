class AdminController < ApplicationController
  layout 'user'
  before_filter :confirm_logged_in_admin, :except=>[:manager]
  before_filter :confirm_logged_in
  def index
  	@total_orders = Order.count
  	unread
  end

  def manager
  	@items = Item.all
  	inbox
  end
end
