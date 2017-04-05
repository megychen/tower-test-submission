class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_team_permission, :only => [:show, :edit, :update, :destroy]

  def index
    @teams = current_user.teams
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    if @team.save
      memb = @team.members.create
      memb.user_id = current_user.id
      memb.name = current_user.user_name
      memb.email = current_user.email
      memb.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @team = Team.find(params[:id])
    project_accesses = current_user.accesses.select("project_id")
    @projects = @team.projects.where(id: project_accesses)
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to root_path
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def check_team_permission
    @team = Team.find(params[:id])
    unless current_user.has_permission_to_team?(@team)
      flash[:alert] = "你不是这个团队成员"
      redirect_to root_path
    end
  end
end
