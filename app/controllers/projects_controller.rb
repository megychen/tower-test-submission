class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
  end

  def new
    @team = Team.find(params[:team_id])
    @project = Project.new
  end

  def create
    @team = Team.find(params[:team_id])
    @project = Project.new(project_params)
    @project.team = @team
    if @project.save
      redirect_to team_path(@team)
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
