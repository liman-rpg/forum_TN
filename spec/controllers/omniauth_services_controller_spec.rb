require 'rails_helper'

RSpec.describe OmniauthServicesController, type: :controller do
  describe "GET #request_email" do
    before { get :request_email }

    it 'render template' do
      expect(response).to render_template :request_email
    end
  end

  describe "POST #save_email" do
    context 'email delivered' do
      let(:save_email) {
        post :save_email,
        params: { email: 'test@test.com' },
        session: { 'devise.uid' => '12345', 'devise.provider' => 'twitter'}
      }

      it 'render template' do
        save_email
        expect(response).to redirect_to new_user_session_path
      end

      it 'sends an email' do
        expect { save_email }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'email not delivered' do
      it 'render request_email view' do
        post :save_email, params: { email: '' }
        expect(response).to render_template :request_email
      end
    end
  end

  describe 'GET #confirm_email' do
    context 'with valid attributes' do
      let!(:auth) { create(:authorization) }
      let!(:confirm_token) { auth.confirm_token }
      before { get :confirm_email, params: { token: confirm_token } }

      it 'set authorization confirmed status true' do
        auth.reload
        expect(auth.email_confirmed).to eq true
      end

      it 'change authorization to nil' do
        auth.reload
        expect(auth.confirm_token).to eq nil
      end

      it 'redirect to login with provider' do
        expect(response).to redirect_to "/users/auth/#{auth.provider}"
      end
    end

    context 'with invalid attributes' do
      it 'redirect to login with provider' do
        get :confirm_email, params: { provider: nil, uid: nil, token: nil }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
