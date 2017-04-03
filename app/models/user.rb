class User < ApplicationRecord
  after_create :create_team
  after_create :change_onwer

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :teams
  has_many :todos


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

  def change_onwer
    self.team_owner = true
    self.save
  end
end
