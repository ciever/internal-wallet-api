require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user, email: 'test@test.com.au', password: 'password') }

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'signs in the user' do
        post :create, params: { email: user.email, password: 'password' }
        
        expect(session[:user_id]).to eq(user.id)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Signed in successfully.')
      end
    end

    context 'with invalid credentials' do
      it 'does not sign in the user' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password.')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { post :create, params: { email: user.email, password: 'password' } }

    it 'signs out the user' do
      delete :destroy
      
      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Signed out successfully.')
    end
  end
end
