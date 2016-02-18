class HitStatsController < ApplicationController
  before_filter :authenticate_user!
  def index
    # select ip, campaign_id, hits from hit_stats order by ip, hits;
    # select ip, sum(hits) hits from hit_stats group by ip order by hits;
    @hit_stats = HitStat.order('ip, hits').all
    @hit_stats_by_ip = HitStat.by_ip.order('hits').all
  end
end
