require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5) }

  it { should have_db_column(:best).of_type(:boolean).with_options(default: false) }

  describe 'set_as_best' do
    let!(:answer) { create(:answer, best: false) }

    it "change :best to true" do
      answer.set_as_best
      expect(answer.best).to eq true
    end
  end
end
