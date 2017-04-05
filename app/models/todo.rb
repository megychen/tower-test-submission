class Todo < ApplicationRecord
  include PublicActivity::Model
  tracked

  validates :title, presence: true
  belongs_to :project
  belongs_to :user, :optional => true
  has_many :comments

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

  tracked owner: Proc.new{ |controller, model| controller.current_user }
end

# t.string   "trackable_type"
# t.integer  "trackable_id"
# t.string   "owner_type"
# t.integer  "owner_id"
# t.string   "key"
# t.text     "parameters"
# t.string   "recipient_type"
# t.integer  "recipient_id"
