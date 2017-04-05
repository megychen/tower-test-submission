class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = Team.find(params[:team_id])
    project_permissions = current_user.accesses.select("user_id")
    @activities = PublicActivity::Activity.where(:owner_id => project_permissions).order('created_at DESC').limit(50)
  end
end
