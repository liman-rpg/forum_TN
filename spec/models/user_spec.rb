require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :name }

  describe 'author_of?' do
    let(:author)       { create(:user) }
    let(:another_user) { create(:user) }
    let(:object)       { create(:answer, user: author) }

    it 'true/false' do
      expect(author.author_of?(object)).to eq true
      expect(another_user.author_of?(object)).to eq false
    end
  end

  describe '.from_omniauth' do
    let!(:user) { create :user }
    let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

    context 'user already has authorization' do
      it 'returns user' do
        user.authorizations.create(provider: 'facebook', uid: '12345')
        expect(User.from_omniauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create new user' do
          expect{ User.from_omniauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect{ User.from_omniauth(auth) }.to change(user.authorizations, :count).by(+1)
        end

        it 'creates authorization with provider and uid' do
          user = User.from_omniauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the users' do
          expect(User.from_omniauth(auth)).to eq user
        end
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
      end

      it 'fills user email' do
        user = User.from_omniauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        user = User.from_omniauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.from_omniauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns new user' do
        expect(User.from_omniauth(auth)).to be_a(User)
      end
    end
  end
end
