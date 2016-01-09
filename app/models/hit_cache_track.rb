class HitCacheTrack < ActiveRecord::Base
  belongs_to :hit

  def self.among_recent_hits?(ip, c_id)
    sql = "SELECT hit_cache_start from hit_cache_tracks WHERE ip='#{ip}' AND campaign_id='#{c_id}' LIMIT 1"
    results = HitCacheTrack.connection.execute(sql)
    row = results.map{|row| row} 
    hit_cache_start = row.flatten[0]
    # track = self.where(:ip => ip, :campaign_id => c_id).last
    if hit_cache_start.present?
      # hit   = track.hit
      return (Time.now.to_i  - hit_cache_start.to_i) < Sysconfig.singleton.hit_cache_timeout.minutes.to_i
    else
      return false
    end
  end

  def self.find_or_create_by_ip_and_campaign_id(ip,c_id)
    # sql = "SELECT hit_cache_start from hit_cache_tracks WHERE ip='#{ip}' AND campaign_id='#{c_id}' LIMIT 1"
    # results = HitCacheTrack.connection.execute(sql)
    # row = results.map{|row| row} 
    # hit_cache_start = row.flatten[0]    
    track = self.where(:ip => ip, :campaign_id => c_id).last
    track.present? ? track : HitCacheTrack.create(ip:ip, campaign_id:c_id)
  end
end
