class MembersController < ApplicationController
  def index
    @team = Team.find(params[:team_id])
    @members = @team.members
  end
end
