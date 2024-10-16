require 'rails_helper'

RSpec.describe Wallet, type: :model do
  let(:user) { create(:user) }
  let(:team) { create(:team) }
  let(:user_wallet) { create(:wallet, walletable: user) }
  let(:team_wallet) { create(:wallet, walletable: team) }

  describe 'associations' do
    it { is_expected.to belong_to(:walletable) }
    it { is_expected.to have_many(:outgoing_transactions).class_name('Transaction').with_foreign_key(:source_wallet_id).dependent(:destroy) }
    it { is_expected.to have_many(:incoming_transactions).class_name('Transaction').with_foreign_key(:target_wallet_id).dependent(:destroy) }
  end

	describe '#balance' do
    it 'calculates the balance correctly' do
			# to imporve this code I would add a factory for 'transaction'
      Transaction.create(source_wallet: nil, target_wallet: user_wallet, amount: 100.00)
      Transaction.create(source_wallet: user_wallet, target_wallet: team_wallet, amount: 10.05)
      Transaction.create(source_wallet: user_wallet, target_wallet: team_wallet, amount: 10.20)
      Transaction.create(source_wallet: team_wallet, target_wallet: user_wallet, amount: 5.59)
      Transaction.create(source_wallet: user_wallet, target_wallet: team_wallet, amount: 0.95)
			
      expect(user_wallet.balance).to eq(84.39)
      expect(team_wallet.balance).to eq(15.61)
    end
  end
end
