class Member < ApplicationRecord
  belongs_to :team
  validates :email, presence: true
end
