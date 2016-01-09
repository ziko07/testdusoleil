
class HitStat < ActiveRecord::Base
  
  def self.populate_table
    transaction do 
      month_ago = Date.today - 30
      connection.execute "drop view if exists hits_by_campaign"
      connection.execute %Q[
        create view hits_by_campaign as 
        (select campaign_id, count(campaign_id) hits_count from hits where created_at > '#{month_ago}' group by campaign_id) 
        union (select campaign_id, count(campaign_id) hits_count from hits_archive where created_at > '#{month_ago}' 
        group by campaign_id)
      ]
      connection.execute "drop table if exists hit_stats"
      connection.execute %Q[
        create table hit_stats (
          id int(11) not null auto_increment,
          campaign_id int(11),
          ip varchar(255),
          hits int(11),
          primary key (id)
        )
      ]
      connection.execute %Q[
        insert into hit_stats (campaign_id, ip, hits) select h.campaign_id, t.ip, sum(h.hits_count) 
        from hits_by_campaign h join campaigns c on h.campaign_id = c.id 
        join trackers t on t.domain = c.tracker group by h.campaign_id
      ]
      # select ip, campaign_id, hits from hit_stats order by ip, hits;
      # select ip, sum(hits) hits from hit_stats group by ip order by hits;
    end
  end

  # can we use scope?
  def self.by_ip
    select("ip, sum(hits) hits").group("ip")
  end
end

