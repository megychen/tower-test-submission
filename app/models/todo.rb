class Todo < ApplicationRecord
  after_create :create_assignment
  after_create :generate_event
  after_update :generate_todo_status_event

  validates :title, presence: true
  belongs_to :project
  has_many :events, :dependent => :destroy
  belongs_to :user, :optional => true
  has_many :comments
  has_one :assignment, :dependent => :destroy
  accepts_nested_attributes_for :assignment, allow_destroy: true

  include AASM

  aasm do
    state :created, initial: true
    state :processing
    state :deleted
    state :completed

    event :start do
      transitions from: :created, to: :processing
    end

    event :pause do
      transitions from: :processing, to: :created
    end

    event :completed do
      transitions from: %i(created processing), to: :completed
    end

    event :reopen do
      transitions from: :completed, to: :created
    end

    event :deleted do
      transitions from: %i(created processing), to: :deleted
    end
  end

  def create_assignment
    if self.user_id.present?
      Assignment.create!(user_id: self.user_id, todo_id: self.id, deadline: self.deadline)
    end
  end

  def generate_event
    Event.create!(user_id: self.user_id, project_id: self.project_id, todo_id: self.id, action: "创建了任务:")
  end

  def generate_todo_status_event
    if self.aasm_state_changed? && self.aasm_state == "processing"
      Event.create!(user_id: self.user.id, project_id: self.project.id, todo_id: self.id, action: "开始了任务:")
    elsif self.aasm_state_was == "processing" && self.aasm_state == "created"
      Event.create!(user_id: self.user.id, project_id: self.project.id, todo_id: self.id, action: "暂停了任务:")
    elsif self.aasm_state_changed? && self.aasm_state == "completed"
      Event.create!(user_id: self.user.id, project_id: self.project.id, todo_id: self.id, action: "完成了任务:")
    elsif self.aasm_state_was == "completed" && self.aasm_state == "created"
      Event.create!(user_id: self.user.id, project_id: self.project.id, todo_id: self.id, action: "重新打开了任务:")
    end
  end

end
