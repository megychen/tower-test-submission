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
    @user = User.find_by_id!(@access[:user_id])
    if !@user.is_project_member_of?(@project) && @access.save!
      redirect_to team_project_path(@team,@project)
      flash[:notice] = "成功邀请成员"
    else
      flash[:warning] = "请输入邀请成员或成员已在该团队"
      render :new
    end
  end

  def destroy
    @access = Access.find_by(user_id: current_user.id, project_id: @project.id)
    @access.destroy
    redirect_to team_path(@team), alert: "你已退出项目"
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
