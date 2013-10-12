class AdminController < ApplicationController
  layout 'user'
  def index
  	@total_orders = Order.count
  end
end
