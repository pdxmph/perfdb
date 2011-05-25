class Vertical < ActiveRecord::Base
  
  has_many :sites
  has_many :articles, :through => :sites
end
