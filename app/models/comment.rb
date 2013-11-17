class Comment < ActiveRecord::Base
   attr_accessible :title, :email, :name, :description
   validates :name, :description, :presence=>true
   EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9._]+\.[A-Z]{2,4}$/i
  validates :email,:length=>{:maximum=>100}, :format=>EMAIL_REGEX,:confirmation=>true
end
