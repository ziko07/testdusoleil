class UserAgent < ActiveRecord::Base
  has_many :campaigns, :through => :hit_counts
  has_many :hit_counts
  
end