class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team_and_project
  before_action :find_todo_list, :except => [:index, :new, :create]
  before_action :assign_todo, :only => [:start, :pause, :completed, :reopne]
  before_action :check_project_permission, :only => [:show, :edit, :update, :destroy, :move_up, :move_down]

  def index
    @todos = @project.todos.order("position ASC")
  end

  def new
    @todo = Todo.new
    @assignment = Assignment.new
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.user_id = params[:user_id]
    @todo.project = @project

    if @todo.save!
      redirect_to team_project_path(@team,@project)
    else
      render "projects/show"
    end
  end

  def show
    @comment = Comment.new
  end

  def edit
  end

  def update
    @todo.user_id = params[:user_id]
    @todo.update(todo_params)
    if @todo.save
      redirect_to team_project_path(@team, @project)
    else
      render :edit
    end
  end

  def destroy
    @todo.destroy

    redirect_to team_project_path(@team, @project)
  end

  def start
    @todo.start!
    redirect_to :back
  end

  def pause
    @todo.pause!
    flash[:notice] = "停止处理任务"
    redirect_to :back
  end

  def completed
    @todo.completed!
    flash[:notice] = "已完成任务"
    redirect_to :back
  end

  def reopen
    @todo.reopen!
    flash[:notice] = "重新打开任务"
    redirect_to :back
  end

  def deleted
    @todo.deleted!
    flash[:notice] = "删除任务"
    redirect_to :back
  end

  def move_up
    @todo.move_higher
    redirect_to :back
  end

  def move_down
    @todo.move_lower
    redirect_to :back
  end

  private

  def find_team_and_project
    @team = Team.find(params[:team_id])
    @project = Project.find(params[:project_id])
  end

  def find_todo_list
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :user_id, :deadline)
  end

  def assign_todo
    if @todo.user_id == nil
      redirect_to :back, alert: "请先指派任务"
    end
  end

  def check_project_permission
    @project = @todo.project
    unless current_user.has_permission_to_project?(@project)
      flash[:warning] = "You have no permission"
      redirect_to "/"
    end
  end
end
