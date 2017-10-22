require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5) }

  it { should have_db_column(:best).of_type(:boolean).with_options(default: false) }

  describe 'set_as_best' do
    let!(:question)      { create(:question) }
    let!(:answer)        { create(:answer, question: question, best: false) }
    let!(:answer_best)   { create(:answer, question: question, best: true) }
    let!(:other_answer)  { create(:answer, question: question, best: false) }

    it "change the selected answer :best to true" do
      answer.set_as_best
      expect(answer.best).to eq true
    end

    it "change other answers :best to false" do
      answer.set_as_best
      answer_best.reload
      other_answer.reload

      expect(other_answer.best).to eq false
      expect(answer_best.best).to eq false
    end
  end
end
