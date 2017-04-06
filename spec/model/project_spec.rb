require 'rails_helper'
RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:todos) }
  it { is_expected.to have_many(:accesses) }
  it { is_expected.to have_many(:events) }
end
