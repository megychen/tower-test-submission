class Team < ApplicationRecord
  belongs_to :user
  has_many :projects
  validates :name, presence: true
end
