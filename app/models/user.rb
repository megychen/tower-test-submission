class User < ApplicationRecord
  after_create :create_team
  validates :user_name, presence: true
  validates :team_name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :teams
  has_many :todos
  has_many :comments
  has_many :accesses
  has_many :projects
  has_many :events
  has_many :assignments, dependent: :destroy
  has_many :team_permissions

  def create_team
    tm = teams.build
    tm.user_id = self.id
    tm.name = self.team_name
    tm.save
  end

  def is_team_member_of?(team)
    team.team_permissions.exists?(user_id: self.id)
  end

  def is_project_member_of?(project)
    project.accesses.exists?(user_id: self.id)
  end

  def has_permission_to_project?(project)
    access = self.accesses.find_by_project_id(project.id)
    if access.present?
      true
    else
      false
    end
  end
end
