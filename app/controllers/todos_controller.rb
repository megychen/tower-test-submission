class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team_and_project
  before_action :find_todo_list, :except => [:index, :new, :create]
  before_action :stop_public_activity, :only => [:update, :start, :pause, :completed, :reopen]

  def index
    @todos = @project.todos
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.project = @project
    @todo.user_id = params[:user_id]
    if @todo.save!
      redirect_to :back
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
    Todo.public_activity_off
    @todo.update(todo_params)
    if @todo.save
      redirect_to team_project_path(@team, @project)
    else
      render :edit
    end
  end

  def destroy
    @todo.destroy

    redirect_to :back
  end

  def start
    @todo.start!
    Todo.public_activity_on
    @todo.create_activity :start
    flash[:notice] = "开始处理任务"
    redirect_to :back
  end

  def pause
    @todo.pause!
    Todo.public_activity_on
    @todo.create_activity :pause
    flash[:notice] = "停止处理任务"
    redirect_to :back
  end

  def completed
    @todo.completed!
    Todo.public_activity_on
    @todo.create_activity :completed
    flash[:notice] = "已完成任务"
    redirect_to :back
  end

  def reopen
    @todo.reopen!
    Todo.public_activity_on
    @todo.create_activity :reopen
    flash[:notice] = "重新打开任务"
    redirect_to :back
  end

  def deleted
    @todo.deleted!
    flash[:notice] = "删除任务"
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

  def stop_public_activity
    Todo.public_activity_off
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :user_id, :deadline)
  end
end
