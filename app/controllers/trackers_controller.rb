class TrackersController < AdminController
  before_filter :get_tracker, :except => [:index, :new, :create]
  
  def index
    @trackers = Tracker.all
  end

  def new
    @tracker = Tracker.new
    render :action => "show"
  end

  def show
  end

  def create
    puts()
    @tracker = Tracker.new(params[:tracker])
    if @tracker.save
      redirect_to(@tracker, :notice => 'Tracker was successfully created.')
    else
      render :action => "show"
    end
  end

  def update
    if @tracker.update_attributes(params[:tracker])
      redirect_to(@tracker, :notice => 'Campaign was successfully updated.')
    else
      render :action => "show"
    end
  end

  def destroy
    @tracker.destroy
    redirect_to(trackers_path)
  end

  protected
  def get_tracker
    @tracker = Tracker.where(:id => params[:id]).first
  end
end
