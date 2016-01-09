class HitCount < ActiveRecord::Base
  belongs_to :user_agent
  belongs_to :campaign
end