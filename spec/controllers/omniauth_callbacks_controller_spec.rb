require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe "#facebook" do
    let(:user) { create(:user) }

    before { request.env["devise.mapping"] = Devise.mappings[:user] }

    context 'user does not exist' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: 'new@user.com', name: 'AuthName' })
        get :facebook
      end

      it 'should redirect_to root_path' do
        expect(response).to redirect_to root_path
      end

      it 'signin user' do
        expect(controller.current_user).to eq User.first
      end
    end

    context 'user exist' do
      let(:auth) { create(:authorization, user: user) }

      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: auth.provider, uid: auth.uid, info: { email: user.email })
        get :facebook
      end

      it 'should redirect_to root_path' do
        expect(response).to redirect_to root_path
      end

      it 'signin user' do
        expect(controller.current_user).to eq user
      end
    end
  end

  describe "#twitter" do
    let(:user) { create(:user) }

    before { request.env["devise.mapping"] = Devise.mappings[:user] }

    context 'user does not exist' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '12345', info: { name: 'AuthName' })
        get :twitter
      end

      it 'should redirect_to request_email' do
        redirect_to request_email_path
      end
    end

    context 'user exist' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: auth.provider, uid: auth.uid)
        get :twitter
      end

      context 'with not email confirmed' do
        let(:auth) { create(:authorization, :not_email_confirmed, user: user) }

        it 'should redirect_to new_user_registration_path' do
          expect(response).to redirect_to new_user_registration_path
        end
      end

      context 'with email confirmed' do
        let(:auth) { create(:authorization, :email_confirmed, user: user) }

        it 'should redirect_to root_path' do
          expect(response).to redirect_to root_path
        end

        it 'signin user' do
          expect(controller.current_user).to eq user
        end
      end
    end
  end
end
