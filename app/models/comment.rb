class Comment < ApplicationRecord
  include PublicActivity::Model
  tracked
  belongs_to :user
  belongs_to :todo

  tracked owner: Proc.new{ |controller, model| controller.current_user }
end
