class Project < ApplicationRecord
  include PublicActivity::Model
  tracked

  after_create :add_project_permission
  validates :title, presence: true
  belongs_to :team
  has_many :todos
  belongs_to :user

  def add_project_permission
    Access.create(user_id: self.user.id, project_id: self.id, permission: "owner")
  end

  tracked owner: Proc.new{ |controller, model| controller.current_user }

end
