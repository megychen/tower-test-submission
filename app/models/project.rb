class Project < ApplicationRecord
  validates :title, presence: true
  belongs_to :team
  has_many :todos
end
