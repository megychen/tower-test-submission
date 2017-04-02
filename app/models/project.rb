class Project < ApplicationRecord
  validates :title, presence: true
  belongs_to :team
end
