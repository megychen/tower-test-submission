class Todo < ApplicationRecord
  validates :title, presence: true
  belongs_to :project
  belongs_to :user, :optional => true

  include AASM

  aasm do
    state :created, initial: true
    state :processing
    state :deleted
    state :completed

    event :start do
      transitions from: :created, to: :processing
    end

    event :pause do
      transitions from: :processing, to: :created
    end
    
    event :completed do
      transitions from: %i(created processing), to: :completed
    end

    event :reopen do
      transitions from: :completed, to: :created
    end

    event :delete do
      transitions from: %i(created processing), to: :deleted
    end
  end
end
