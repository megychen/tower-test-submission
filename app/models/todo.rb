class Todo < ApplicationRecord
  after_create :create_assignment
  include PublicActivity::Model
  tracked

  validates :title, presence: true
  belongs_to :project
  belongs_to :user, :optional => true
  has_many :comments
  has_one :assignment, :dependent => :destroy
  accepts_nested_attributes_for :assignment, allow_destroy: true

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

    event :deleted do
      transitions from: %i(created processing), to: :deleted
    end
  end

  def create_assignment
    if self.user_id.present?
      Assignment.create!(user_id: self.user_id, todo_id: self.id, deadline: self.deadline)
    end
  end

  tracked owner: Proc.new{ |controller, model| controller.current_user }, except: [:update]
end

# t.string   "trackable_type"
# t.integer  "trackable_id"
# t.string   "owner_type"
# t.integer  "owner_id"
# t.string   "key"
# t.text     "parameters"
# t.string   "recipient_type"
# t.integer  "recipient_id"
