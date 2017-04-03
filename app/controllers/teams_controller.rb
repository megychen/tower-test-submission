class TeamsController < ApplicationController
  before_action :authenticate_user!

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
    @projects = @team.projects
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

  def invite
    @team = Team.find(params[:team_id])
    @user = User.find_by_email(:email => params[:email])
    memb = @team.members.build
    mem.name = @user.user_name
    mem.email = @user.email
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
