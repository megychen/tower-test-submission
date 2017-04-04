class User < ApplicationRecord
  after_create :create_team

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :teams
  has_many :todos
  has_many :comments


  def create_team
    tm = teams.build
    tm.user_id = self.id
    tm.name = self.team_name
    tm.save
    memb = tm.members.create
    memb.user_id = self.id
    memb.name = self.user_name
    memb.email = self.email
    memb.save
  end

  def has_permission_to_team?(team)
    team.members.exists?(user_id: self.id)
  end

end
