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
end
