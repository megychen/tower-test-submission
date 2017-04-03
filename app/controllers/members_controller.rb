class MembersController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = Team.find(params[:team_id])
    @members = @team.members
  end

  def new
    @team = Team.find(params[:team_id])
    @member = Member.new
  end

  def create
    @team = Team.find(params[:team_id])
    @member = Member.new(member_params)
    @member.team = @team
    @user = User.find_by_email(@member.email)
    if @user.present?
      #@member.user_id = @user.id
      @member.name = @user.user_name
      @member.save
      redirect_to team_members_path(@team)
    else
      render :new
    end
  end

  def edit
    @team = Team.find(params[:team_id])
    @member = Member.find(params[:id])
  end

  def update
    @team = Team.find(params[:team_id])
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to team_members_path(@team)
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:team_id])
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to team_members_path(@team)
  end

  private

  def member_params
    params.require(:member).permit(:name, :email)
  end
end
