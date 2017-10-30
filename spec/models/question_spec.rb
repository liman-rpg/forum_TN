require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should validate_length_of(:body).is_at_least(5) }

  describe "Voting" do
    let(:model)  { create(:question) }
    let(:user)   { create(:user) }

    describe '#vote_up' do
      it 'create new vote with score = 1' do
        expect { model.vote_up(user) }.to change(model.votes, :count).by(1)
        expect(model.votes.first.score).to eq 1
      end
    end

    describe '#vote_down' do
      it 'create new vote with score = -1' do
        expect { model.vote_down(user) }.to change(model.votes, :count).by(1)
        expect(model.votes.first.score).to eq -1
      end
    end
  end
end
