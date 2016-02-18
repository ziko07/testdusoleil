class TrackersController < ApplicationController
  before_filter :get_tracker, :except => [:index, :new, :create]
  before_filter :authenticate_user!
  def index
    if current_user.is_admin
      @trackers = Tracker.all
    else
      @trackers = current_user.trackers
    end
  end

  def new
    @tracker = Tracker.new
    render :action => "show"
  end

  def show
  end

  def create
    @tracker = Tracker.new(params[:tracker])
    if @tracker.save
      redirect_to(admin_trackers_path, :notice => 'Tracker was successfully created.')
    else
      render :action => "show"
    end
  end

  def update
    if @tracker.update_attributes(params[:tracker])
      redirect_to(admin_dashboard_path, :notice => 'Campaign was successfully updated.')
    else
      render admin_dashboard_path
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
