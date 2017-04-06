require 'rails_helper'
RSpec.describe Event, type: :model do
  it { is_expected.to have_many(:projects) }
  it { is_expected.to have_many(:accesses) }
  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:todos) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:assignments) }
  it { is_expected.to have_many(:team_permissions) }
end





has_many :assignments, dependent: :destroy
has_many :team_permissions
