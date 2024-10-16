require 'rails_helper'

RSpec.describe Stock, type: :model do
  subject { build(:stock) }

  describe 'associations' do
    it { is_expected.to have_one(:wallet).dependent(:destroy) }
  end
end