class Assignment < ApplicationRecord
  after_create :generate_to_assign_event1
  after_update :generate_to_assign_event2

  belongs_to :todo
  belongs_to :user

  def generate_to_assign_event1
    Event.create!(user_id: self.user_id, project_id: self.todo.project.id, todo_id: self.todo.id, action: "指派了任务:")
  end

  def generate_to_assign_event2
    if self.user_id.present? && self.user_id_changed?
      Event.create!(user_id: self.user_id, project_id: self.todo.project.id, todo_id: self.todo.id, action: "重新指派了任务完成者:")
    elsif self.deadline.present? && self.deadline_changed?
      Event.create!(user_id: self.user_id, project_id: self.todo.project.id, todo_id: self.todo.id, action: "修改了任务完成时间:")
    end
  end
end
