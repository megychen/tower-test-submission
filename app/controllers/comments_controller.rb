class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team_project_todo
  before_action :find_comment, :only => [:edit, :update, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.todo = @todo
    @comment.user = current_user
    if @comment.save
      redirect_to :back
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to team_project_todo_path(@team,@project,@todo)
    else
      render :edit
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    redirect_to :back
  end

  private

  def find_team_project_todo
    @team = Team.find(params[:team_id])
    @project = Project.find(params[:project_id])
    @todo = Todo.find(params[:todo_id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
