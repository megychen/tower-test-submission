class Assignment < ApplicationRecord
  include PublicActivity::Model
  tracked

  belongs_to :todo
  belongs_to :user

  tracked owner: Proc.new{ |controller, model| controller.current_user }
end
