class SocialStat < ActiveRecord::Base
  belongs_to :site
  belongs_to :social_site
end
