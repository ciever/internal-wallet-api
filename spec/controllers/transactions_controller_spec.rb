require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:team) { create(:team) }

  before do
    # Add funds to user
    service = Services::TransactionService.new(nil, user.wallet, 1000)
    service.call

    # Simulate user signing in
    session[:user_id] = user.id
  end

  describe 'POST #create' do
  	context 'with valid transaction params' do
			let(:valid_params) do
				{
					transaction: {
						source: {
							type: 'User',
							id: user.id
						},
						target: {
							type: 'Team',
							id: team.id
						},
						amount: 10.00
					}
				}
			end

      it 'creates a transaction and returns success' do
        expect {
          post :create, params: valid_params
        }.to change { Transaction.count }.by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq('success')
      end
    end
		
    context 'with invalid transaction params' do
      let(:invalid_params) do
        {
          transaction: {
            source: {},
            target: {},
            amount: 10.00
          }
        }
      end

      it 'does not create a transaction and returns error' do
        expect {
          post :create, params: invalid_params
        }.not_to change { Transaction.count }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('error')
      end
    end

    context 'when user is not authenticated' do
      before do
        session[:user_id] = nil # Simulate a user not signed in
      end

      it 'returns unauthorized status' do
        post :create, params: { transaction: { amount: 10.00  } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
