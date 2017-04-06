require 'rails_helper'
RSpec.describe Event, type: :model do
  it { is_expected.to have_many(:projects) }
  it { is_expected.to have_many(:team_permissions) }
end
