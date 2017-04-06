class TeamPermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team

  def new
    @team_permission = TeamPermission.new
  end

  def create
    @team_permission = TeamPermission.new(team_permission_params)
    @team_permission.team_id = @team.id
    @user = User.find_by_email(@team_permission[:email])
    if @user.present?
      @team_permission.user_id = @user.id
      if !@user.is_team_member_of?(@team) && @team_permission.save!
        redirect_to members_team_path(@team)
        flash[:notice] = "成功邀请成员"
      else
        flash[:warning] = "请重新输入邀请成员或成员已在团队"
        render :new
      end
    else
      redirect_to :back, alert: "该用户不存在"
    end
  end

  def destroy
    @permission = TeamPermission.find(params[:id])
    @permission.destroy
    flash[:alert] = "已移除成员"
    redirect_to members_team_path(@team)
  end

  private

  def team_permission_params
    params.require(:team_permission).permit(:user_id, :team_id, :permission, :email)
  end

  def find_team
    @team = Team.find(params[:team_id])
  end
end
