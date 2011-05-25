class Editor < ActiveRecord::Base
  
  has_many :articles
  has_many :sites
  has_many :authors, :through => :articles
  has_many :articles, :through => :sites
end
