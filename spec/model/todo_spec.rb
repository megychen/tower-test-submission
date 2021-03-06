require 'rails_helper'
RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_one(:assignment) }
end
