class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team
  before_action :find_team_and_project, :only => [:edit, :uupdate, :destroy]
  before_action :check_team_permission, :except => [:index, :show]

  def index
    @members = @team.members
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.team = @team
    @user = User.find_by_email(@member.email)
    if @user.present?
      @member.user_id = @user.id
      @member.name = @user.user_name
      @member.save
      flash[:notice] = "邀请成员成功"
      redirect_to team_members_path(@team)
    else
      flash[:notice] = "该成员不存在"
      render :new
    end
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to team_members_path(@team)
    else
      render :edit
    end
  end

  def destroy
    @member.destroy
    redirect_to team_members_path(@team)
  end

  private

  def find_team
    @team = Team.find(params[:team_id])
  end

  def find_team_and_project
    @member = Member.find(params[:id])
  end

  def check_team_permission
    @team = Team.find(params[:team_id])
    unless current_user.has_permission_to_team?(@team)
      redirect_to "/", notice: "You have no permission"
    end
  end

  def member_params
    params.require(:member).permit(:name, :email)
  end
end
