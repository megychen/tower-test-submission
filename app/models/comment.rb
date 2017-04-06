class Comment < ApplicationRecord
  after_create :generate_event
  belongs_to :user
  belongs_to :todo

  def generate_event
    Event.create!(user_id: self.user_id, project_id: self.todo.project_id, todo_id: self.todo.id, action: "回复了任务:")
  end
end
