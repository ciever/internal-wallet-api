require 'rails_helper'

RSpec.describe Team, type: :model do
  subject { build(:team) }

  describe 'associations' do
    it { is_expected.to have_one(:wallet).dependent(:destroy) }
  end
end
