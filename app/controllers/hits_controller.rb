class HitsController < ApplicationController
  # skip_before_filter :authenticate!, :only => [:create,:check_hit]
  skip_before_filter :authenticate_user!, :only => [:create, :check_hit]
  # GET /hits
  def index
    if current_user.is_admin
      @hits = Hit.order('created_at desc, passed desc').limit(100)
      @show_campaign_id_column = true
    else
      @hits = Hit.where(campaign_id: current_user.campaigns.map(&:id)).order('created_at desc, passed desc').limit(100)
      @show_campaign_id_column = true
    end
  end

  # POST /hits/ban/1
  def ban
    @hit = Hit.where(:id => params[:id]).first
    Blockip.create(:ip => @hit.ip, :source => 'hit', user_id: @hit.campaign.user_id)
    if params[:campaign_id]
      redirect_to hits_campaign_path(params[:campaign_id]), :notice => "The IP '#{@hit.ip}' has been banned."
    else
      redirect_to hits_path, :notice => "The IP '#{@hit.ip}' has been banned."
    end
  end

  # GET /[.js]
  # POST /hits/create
  def create
    sha1 = params[:sha1] || params[:h] || params[:id]
    @campaign = Campaign.cache_it.find(:sha1 => sha1, :archived => false) if sha1
    if @campaign.match_time_zone_flag
      puts("request#{request.inspect}")
      session[:req] = request.fullpath.to_s
      session[:ref] = request.referrer || ''
      @request = request
    else
      req = request.fullpath.to_s
      ref = request.referrer || ''
      lp = Hit.select_lp_from_request(request, @campaign,params[:time_zone],req,ref)
      respond_to do |format|
        format.html { return redirect_to redirection_url(lp) }
        format.js { return render :inline => (lp == :real_lp ? "top.location.replace('#{redirection_url(lp)}')" : "") }
      end
      return render :text => nil, :layout => false unless @campaign
    end
  end

  def check_hit
    @campaign = Campaign.find_by_id(params[:id])
    req = session[:req]
    ref = session[:ref]
    puts("Req#{req.inspect}")
    lp = Hit.select_lp_from_request(request, @campaign,params[:time_zone],req,ref)
    respond_to do |format|
      format.html { return redirect_to redirection_url(lp) }
      format.js { return render :inline => (lp == :real_lp ? "top.location.replace('#{redirection_url(lp)}')" : "") }
    end
  end

  def error_logs
    @errors = DusoleilErrors.order('created_at desc').limit(100)
  end

  private
  def redirection_url(lp)
    @campaign.rekeyed_lp(request.fullpath, lp)
  end
end
