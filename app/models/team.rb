class Team < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :projects, dependent: :destroy
  validates :name, presence: true
  has_many :members, dependent: :destroy
end
