class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = Team.find(params[:team_id])
    @activities = PublicActivity::Activity.order('created_at DESC').limit(50)
  end
end
