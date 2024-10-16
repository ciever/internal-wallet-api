require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { Transaction.new(amount: 10, source_wallet: nil, target_wallet: nil) }

  describe 'associations' do
    it { is_expected.to belong_to(:source_wallet).class_name('Wallet').optional }
    it { is_expected.to belong_to(:target_wallet).class_name('Wallet').optional }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

    context 'when wallets are not present' do
      it 'is invalid without source or target wallet' do
        expect(subject).not_to be_valid
        expect(subject.errors[:base]).to include('Please add a target or source wallet.')
      end
    end
  end
end
