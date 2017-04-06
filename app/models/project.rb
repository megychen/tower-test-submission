class Project < ApplicationRecord
  after_create :add_project_permission
  after_create :generate_event

  validates :title, presence: true
  belongs_to :team
  has_many :todos
  belongs_to :user
  has_many :accesses
  has_many :events

  def add_project_permission
    Access.create(user_id: self.user.id, project_id: self.id, permission: "owner")
  end

  def generate_event
    Event.create!(user_id: self.user.id, project_id: self.id, action: "创建了项目:")
  end

end

# t.string   "trackable_type"
# t.integer  "trackable_id"
# t.string   "owner_type"
# t.integer  "owner_id"
# t.string   "key"
# t.text     "parameters"
# t.string   "recipient_type"
# t.integer  "recipient_id"
