class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team
  before_action :find_project, :only => [:show, :edit, :destroy, :update]
  before_action :check_owner_permission, :only => [:edit, :destroy, :update]

  def show
    @todo = Todo.new
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.team = @team
    @project.user = current_user
    if @project.save
      redirect_to team_path(@team)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to team_project_path(@team, @project)
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to :back
  end

  private

  def find_team
    @team = Team.find(params[:team_id])
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def check_owner_permission
    @project = Project.find(params[:id])
    unless @project.user == current_user
      redirect_to "/"
    end
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end

end
