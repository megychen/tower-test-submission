require 'rails_helper'
RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:user) }
end
