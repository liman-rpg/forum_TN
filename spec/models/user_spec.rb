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

  # describe '.from_omniauth' do
  #   let!(:user) { create :user }
  #   let(:auth)  { OmniAuth::AuthHash.new(provider: 'Facebook', uid: '12345') }

  #   context 'user already has authorization' do
  #     it 'returns user' do
  #       user.authorization.create(provider: 'Facebook', uid: '12345')
  #       user(User.from_omniauth(auth)).to eq user
  #     end
  #   end
  # end
end
