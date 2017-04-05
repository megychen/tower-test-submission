class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team_project_todo

  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.user_id = params[:user_id]
    @assignment.todo_id = @todo.id
    if @assignment.save!
      @todo.save
      redirect_to team_project_path(@team,@project)
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    @assignment.user_id = params[:user_id]
    @assignment.todo_id = @todo.id
    if @assignment.update(assignment_params)
      @todo.save
      redirect_to team_project_path(@team,@project)
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:user_id, :todo_id, :deadline)
  end

  def find_team_project_todo
    @team = Team.find(params[:team_id])
    @project = Project.find(params[:project_id])
    @todo = Todo.find(params[:todo_id])
  end
end
