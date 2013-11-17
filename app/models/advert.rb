class Advert < ActiveRecord::Base
  attr_accessible :title, :description, :owner, :image_url
  validates :title, :owner,  :description, :presence=>true
end
