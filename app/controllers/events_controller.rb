class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 如果是该项目成员，则要看到该项目下的所有动态
    
    @team = Team.find(params[:team_id])
    #@data = @team.projects[access][user_id]
    #data = @team.projects.map{|c| accesses << c.accesses }
    #@data = @team.projects.map{ |p| p.accesses.select("user_id") }
    project_permissions = current_user.accesses.select("user_id")
    @activities = PublicActivity::Activity.all.where(:owner_id => project_permissions).order('created_at DESC').limit(50)
  end
end
