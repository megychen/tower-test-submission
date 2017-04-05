class Assignment < ApplicationRecord
  include PublicActivity::Model
  tracked

  belongs_to :todo
  belongs_to :user

  tracked except: :destroy, owner: Proc.new{ |controller, model| controller.current_user }
end
