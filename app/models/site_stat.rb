class SiteStat < ActiveRecord::Base
  belongs_to :site
  serialize :preferences
  has_many :social_sites
end
