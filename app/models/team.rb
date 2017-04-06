class Team < ApplicationRecord
  #after_create :change_team_owner
  belongs_to :user
  has_many :projects, dependent: :destroy
  validates :name, presence: true
  has_many :members, dependent: :destroy
  has_many :team_permissions

  def change_team_owner
    TeamPermission.create!(user_id: User.last.id, team_id: self.id, permission: "owner", email: User.last.email)
  end
end
