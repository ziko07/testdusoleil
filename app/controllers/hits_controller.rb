class HitsController < AdminController
  skip_before_filter :authenticate, :only => :create

  # GET /hits
  def index
    @hits = Hit.order('created_at desc, passed desc').limit(100)
    @show_campaign_id_column = true
  end

  # POST /hits/ban/1
  def ban
    @hit = Hit.where(:id => params[:id]).first
    Blockip.create(:ip => @hit.ip, :source => 'hit')
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
    return render :text => nil, :layout => false unless @campaign
    lp = Hit.select_lp_from_request(request, @campaign)
    puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    puts(lp)
    puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    respond_to do |format|
      format.html { return redirect_to redirection_url(lp) }
      format.js { return render :inline => (lp == :real_lp ? "top.location.replace('#{redirection_url(lp)}')" : "") }
    end
  end

  private
  def redirection_url(lp)
    @campaign.rekeyed_lp(request.fullpath, lp)
  end
end
