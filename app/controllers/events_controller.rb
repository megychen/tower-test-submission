class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = Team.find(params[:team_id])
    #@data = @team.projects[access][user_id]
    #data = @team.projects.map{|c| accesses << c.accesses }
    @data = @team.projects.map{ |p| p.accesses.select("user_id") }
    @activities = PublicActivity::Activity.all.where(:owner_id => current_user.id).order('created_at DESC').limit(50)
  end
end
