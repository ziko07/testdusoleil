class SysconfigsController < AdminController
  # GET /system
  def show
    @sysconfig = Sysconfig.singleton
    @hit_ips = Hit.select("ip").group("ip").paginate(:page => params[:ip_page], per_page: 30)
    @user_agents = Hit.select("user_agent, ip").group("user_agent").paginate(:page => params[:agent_page], per_page: 30)
  end

  # PUT /system/1
  def update
    @sysconfig = Sysconfig.singleton
    if @sysconfig.update_attributes(params[:sysconfig])
      redirect_to sysconfigs_path, :notice => 'Sysconfig was successfully updated.'
    else
      render :action => "show"
    end
  end

  # POST /system/unban_me
  def unban_me

    blockips = Blockip.where(:ip => request.ip).all
    notice = "#{request.ip} "
    # if not blockips.all? {|b| b.remote?}
    #   notice << "is on a local block list. See admin."
    # elsif blockips.blank?
    
    if blockips.blank?
      notice << "was not found on the block list."
    else
      Blockip.destroy_ips(blockips)
      notice << "was removed from remote block list."
    end
    redirect_to sysconfigs_path, :notice => notice
  end

  # POST /system/reset_cache
  def reset_cache
    Sysconfig.update(Sysconfig.singleton.id, :hit_cache_start => Time.now)
    redirect_to sysconfigs_path, :notice => "The hit cache has been reset."
  end
  
  def sync_data
    sysconfig = Sysconfig.singleton
    dbhandle = sysconfig.connection.raw_connection   # geb raw connection (gets mysql2 client so we can do raw stuff)
    flash[:notice] = ""
    if params[:sync_user_agents]
      sync_user_agents_sql = "INSERT into user_agents (SELECT DISTINCT '' as id, user_agent as user_agent_string, MD5(user_agent) as user_agent_key, now() as created_at, now() as updated_at from hits) ON DUPLICATE KEY UPDATE updated_at = now()"
      dbhandle.query(sync_user_agents_sql)
      flash[:notice] += "User Agents were synced and #{dbhandle.affected_rows} records were affected."
    end
    
    if params[:sync_hit_counts]
      sync_hit_counts_sql = "INSERT into hit_counts (SELECT '' as id, count(*) as hits_total, 0 as hits_blocked, hits.campaign_id as campaign_id, user_agents.id as user_agent_id, 0 as blocked, '0000-00-00' as blocked_at, 0 as blocked_by, now() as created_at, now() as updated_at FROM hits JOIN user_agents on MD5(hits.user_agent) = user_agents.user_agent_key GROUP BY hits.campaign_id, user_agents.id) ON DUPLICATE KEY UPDATE updated_at = now()"
      dbhandle.query(sync_hit_counts_sql)
      flash[:notice] += "Hit Counts were synced and #{dbhandle.affected_rows} records were added."
    end
    redirect_to sysconfigs_path
    
  end

  def search_ip
    ips    = params[:search_ip]
    agent = params[:search_agent] 
    @sysconfig = Sysconfig.singleton
    if ips.present?
      ips = ips.gsub(/\t/,'').delete(' ').split(",")
      @hit_ips = Hit.select("ip").where(ip:ips).group("ip").paginate(:page => params[:ip_page], per_page: 30)
    else
      @hit_ips = Hit.select("ip").group("ip").paginate(:page => params[:ip_page], per_page: 30)
    end
    
    if agent.present?
      @user_agents = Hit.select("user_agent, ip").where(user_agent:agent).group("user_agent").paginate(:page => params[:agent_page], per_page: 30)
    else
      @user_agents = Hit.select("user_agent, ip").group("user_agent").paginate(:page => params[:agent_page], per_page: 30)
    end
    render :show
  end

  def add_ban_ip
    Blockip.create(:ip => params[:ban_ip].strip, :source => 'sysconfig')
    notice = "The IP '#{params[:ban_ip].strip}' has been banned."
    # redirect_to sysconfigs_path, :notice => notice    
    render json:{success:{msg:notice, ip:params[:ban_ip].strip}}
  end

  def delete_ban_ip
    blockips = Blockip.where(:ip => params[:unban_ip].strip).all
    Blockip.destroy_ips(blockips)
    notice = "The IP '#{params[:unban_ip].strip}' has been unbanned."    
    # redirect_to sysconfigs_path, :notice => notice
    render json:{success:{msg:notice, ip:params[:unban_ip].strip}}
  end

  def upload_ip_list
    ban_ip = params[:ban_ip]
    file_data = params[:ip_list]
    
    if params[:user][:ban_ip] == '1'
      if ban_ip.present?
        blockips = Blockip.where(:ip => ban_ip.strip).all
        Blockip.destroy_ips(blockips)
        notice = "The IP '#{ban_ip.strip}' has been unbanned."
      end      
      
      if file_data.present?
        file_data = file_data.tempfile
        File.open(file_data, 'r') do |file|
          file.each do |line|
            ip_item = line.split(",")
            blockips = Blockip.where(:ip => ip_item[0].strip).all
            Blockip.destroy_ips(blockips)
          end
        end
        notice = "Ip List uploaded is now unbanned."
      end

    else
      if ban_ip.present?
        Blockip.create(:ip => params[:ban_ip].strip, :source => 'sysconfig')
        notice = "The IP '#{ban_ip.strip}' has been banned."
      end

      if file_data.present?
        file_data = file_data.tempfile
        File.open(file_data, 'r') do |file|
          file.each do |line|
            ip_item = line.split(",")
            Blockip.create(:ip => ip_item[0].strip, :source => 'upload csv file')
          end
        end
        notice = "Ip List uploaded is now banned."
      end      
    end
    
    render json:{success:{msg:notice}}
  end

  def add_ban_agent
    hit = Hit.select("user_agent, ip").where(user_agent:params[:ban_agent]).first
    if hit.present?
      Blockip.create(:ip => hit.ip, :source => 'sysconfig')
      notice = "This useragent '#{params[:ban_agent].strip}' has been banned."
    else
      notice = "Can't find this useragent"
    end
    # redirect_to sysconfigs_path, :notice => notice    
    render json:{success:{msg:notice,agent:params[:ban_agent].strip}}
  end

  def delete_ban_agent
    hit = Hit.select("user_agent, ip").where(user_agent:params[:unban_agent].strip).first
    if hit.present?
      blockips = Blockip.where(:ip => hit.ip).all
      Blockip.destroy_ips(blockips)
      notice = "This useragent '#{params[:unban_agent].strip}' has been unbanned."
    else
      notice = "Can't find this useragent"
    end    
    # redirect_to sysconfigs_path, :notice => notice
    render json:{success:{msg:notice,agent:params[:unban_agent].strip}}
  end


  def upload_agent_list
    ban_agent = params[:ban_agent]
    file_data = params[:agent_list]
    hit = nil
    hit = Hit.select("user_agent, ip").where(user_agent:ban_agent.strip).first if ban_agent.present?

    if params[:user][:ban_agent] == '1'
      
      if hit.present?
        blockips = Blockip.where(:ip => hit.ip).all
        Blockip.destroy_ips(blockips)
        notice = "This useragent '#{ban_agent.strip}' has been unbanned."
      end      
      if file_data.present?
        file_data = file_data.tempfile
        File.open(file_data, 'r') do |file|
          file.each do |line|
            ip_item = line.split(",")
            blockips = Blockip.where(:ip => ip_item[0].strip).all
            Blockip.destroy_ips(blockips)
          end
        end
        notice = "UserAgent List uploaded is now unbanned."
      end

    else
      
      if hit.present?
        Blockip.create(:ip => hit.ip, :source => 'sysconfig')
        notice = "This useragent '#{ban_agent.strip}' has been banned."
      end
      if file_data.present?
        file_data = file_data.tempfile
        File.open(file_data, 'r') do |file|
          file.each do |line|
            ip_item = line.split(",")
            Blockip.create(:ip => ip_item[0].strip, :source => 'upload csv file')
          end
        end
        notice = "UserAgent List uploaded is now banned."
      end

    end
    render json:{success:{msg:notice}}
  end
end
