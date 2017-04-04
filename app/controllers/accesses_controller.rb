class AccessesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_team_project

  def new
    @access = Access.new
  end

  def create
    @access = Access.new(access_params)
    @access.project_id = @project.id
    @access.user_id = params[:user_id]
    if @access.save!
      redirect_to team_project_path(@team,@project)
      flash[:notice] = "成功邀请成员"
    else
      flash[:warning] = "请输入邀请成员"
      render :new
    end
  end

  private

  def access_params
    params.require(:access).permit(:user_id, :project_id, :permission)
  end

  def find_team_project
    @team = Team.find(params[:team_id])
    @project = Project.find(params[:project_id])
  end

end
