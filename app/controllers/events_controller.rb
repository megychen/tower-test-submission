class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = Team.find(params[:team_id])
    @activities = PublicActivity::Activity.order('created_at DESC').limit(50)
    #@activities = @activities.group_by { |a| a.trackable_type }
  end
end
