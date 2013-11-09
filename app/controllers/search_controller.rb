class SearchController < ApplicationController
  layout 'user'
  def index
  	@products = Product.where("title LIKE ? ", "%#{params[:search]}%")  
  end

  def self.search(search)
	  return scoped unless search.present?
  		where(['title LIKE ?', "%#{search}%"])
	end
end
