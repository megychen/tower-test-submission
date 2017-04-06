class EventsController < ApplicationController
  before_action :authenticate_user!
  #before_action :check_project_permission

  #   # 如果是该项目成员，则要看到该项目下的所有动态


  def index
    @team = Team.find(params[:team_id])
    project_accesses = current_user.accesses.select("project_id")
    @events = Event.all.order("created_at DESC").where(project_id: project_accesses).limit(50)
  end

  private
end
