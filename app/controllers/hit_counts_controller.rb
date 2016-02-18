class HitCountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.is_admin
      @hit_counts = HitCount.includes(:user_agent).order("hits_total DESC").limit(100)
      @show_campaign_id_column = true
    else

    end
  end

  def block
    @hit_count = HitCount.find(params[:id])
    @first_block = @hit_count.blocked_at == nil ? true : false
    @hit_count.update_attributes(:blocked => params[:hit_count][:blocked], :blocked_at => Time.now() )
    if @hit_count.blocked && @first_block
      dbhandle = @hit_count.connection.raw_connection
      blockips_sql = 'INSERT into blockips (ip,source) ( SELECT ip as ip, "hitcount" '
      blockips_sql += 'as source FROM hits where campaign_id = "'
      blockips_sql += @hit_count.campaign_id.to_s
      blockips_sql += '" AND MD5(user_agent) = "'
      blockips_sql += @hit_count.user_agent.user_agent_key
      blockips_sql += '" )'
      dbhandle.query(blockips_sql)
      @blocked_ips = dbhandle.affected_rows
    end
    if @hit_count.blocked
      flash[:notice] =  "<strong>User Agent Blocked for Campaign ##{@hit_count.campaign_id}!</strong> "
      flash[:notice] += "Also, the <strong>#{@blocked_ips} IPs</strong> from related hits were added to the Global Block IP List." if @first_block
    else
      flash[:alert] = "<strong>Did you mean to do that?</strong> User Agent UnBlocked!"
    end
    redirect_to request.referrer
  end

end
