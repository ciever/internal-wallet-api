require 'rails_helper'

RSpec.describe Services::TransactionService do
  let(:user_wallet) { create(:user).wallet }
  let(:team_wallet) { create(:team).wallet }
  let(:amount) { 100 }
  subject { described_class.new(user_wallet, team_wallet, amount) }

  describe '#initialize' do
    context 'with a valid amount' do
      it 'parses the amount correctly' do
        service = described_class.new(user_wallet, team_wallet, amount)
        expect(service.send(:amount)).to eq(BigDecimal(amount))
      end

      it 'parses the amount from a string' do
				service = described_class.new(user_wallet, team_wallet, '100.50')
        expect(service.send(:amount)).to eq(BigDecimal('100.50'))
      end
    end

    context 'with an invalid amount' do
      it 'raises an error for invalid amount' do
        expect {
          described_class.new(user_wallet, team_wallet, 'invalid_amount')
        }.to raise_error(StandardError, 'Invalid amount: invalid_amount')
      end
    end
  end

  describe '#call' do
    context 'with sufficient balance' do
      before do
				Transaction.create!(source_wallet: nil, target_wallet: user_wallet, amount: 200)
      end

      it 'creates a transaction' do
        expect { subject.call }.to change(Transaction, :count).by(1)
				expect { source}
      end
    end

    context 'with insufficient balance' do
      before do
				Transaction.create(source_wallet: nil, target_wallet: user_wallet, amount: 50)
      end

			it 'checks the source wallet balance' do
        expect(user_wallet.balance).to eq(50)
      end

      it 'raises an error' do
        expect { subject.call }.to raise_error(StandardError, 'Insufficient funds in the source wallet.')
      end
    end

    context 'with an external transaction' do
			subject { described_class.new(nil, team_wallet, 50) } 

      it 'creates a transaction' do
        expect { subject.call }.to change(Transaction, :count).by(1)
				expect(team_wallet.balance).to eq(50)
      end
    end
  end

	describe '#parse_amount' do
    it 'raises an error for invalid amount' do
      service = described_class.new(user_wallet, team_wallet, 0)  # Valid initialization
      expect { service.send(:parse_amount, 'invalid_amount') }.to raise_error(StandardError, 'Invalid amount: invalid_amount')
    end
  end
end
