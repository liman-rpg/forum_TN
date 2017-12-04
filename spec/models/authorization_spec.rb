require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  describe '.find_or_create_authorization' do
    let!(:user)         { create :user }
    let(:auth)          { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
    let(:authorization) { Authorization.find_or_create_authorization(auth) }

    context 'user already has authorization' do
      it 'returns user' do
        user.authorizations.create(provider: 'facebook', uid: '12345')
        expect(authorization.user).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create new user' do
          expect{ authorization }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect{ authorization }.to change(user.authorizations, :count).by(+1)
        end

        it 'creates authorization with provider and uid' do
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the users' do
          expect(authorization.user).to eq user
        end
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com', name: 'AuthName' }) }

      it 'creates new user' do
        expect { authorization }.to change(User, :count).by(1)
      end

      it 'fills user email' do
        expect(authorization.user.email).to eq auth.info.email
      end

      it 'fills user name' do
        expect(authorization.user.name).to eq auth.info.name
      end

      it 'creates authorization for user' do
        user = authorization.user
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns new user' do
        expect(authorization.user).to be_a(User)
      end
    end
  end
end
