class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team, :only => [:show, :edit, :update, :destroy, :members]
  before_action :check_team_permission, :only => [:show]
  before_action :check_team_owner, :only => [:edit, :update, :destroy]

  def index
    #@teams = current_user.teams
    team_permissions = current_user.team_permissions.select("team_id")
    @teams = Team.all.where(id: team_permissions)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    if @team.save
      redirect_to teams_path
    else
      render :new
    end
  end

  def show
    project_accesses = current_user.accesses.select("project_id")
    @projects = @team.projects.where(id: project_accesses)
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    if @team.update(team_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to root_path
  end

  def members
  end

  private

  def team_params
    params.require(:team).permit(:name, :user_id)
  end

  def find_team
    @team = Team.find(params[:id])
  end

  def check_team_permission
    @team = Team.find(params[:id])
    unless current_user.is_team_member_of?(@team)
      flash[:alert] = "你不是这个团队成员"
      redirect_to root_path
    end
  end

  def check_team_owner
    unless current_user == @team.user
      flash[:alert] = "你暂时没有权限"
      redirect_to root_path
    end
  end
end
