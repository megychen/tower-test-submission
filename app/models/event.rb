class Event < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true
  belongs_to :todo, optional: true
end
