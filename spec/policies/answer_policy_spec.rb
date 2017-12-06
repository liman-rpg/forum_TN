require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { AnswerPolicy.new(user, answer) }
  let(:answer) { create :answer }
  let(:user)   { create :user }

  context "for a visitor" do
    let(:user) { nil }

    it { is_expected.to permit_actions([:index, :show]) }
    it { is_expected.to forbid_actions([:destroy, :vote, :set_as_best, :update]) }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'being an author' do
    let(:answer) { create :answer, user: user }

    it { is_expected.to permit_actions([:index, :show, :destroy]) }
    it { is_expected.to forbid_actions([:vote, :set_as_best]) }
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_edit_and_update_actions }
  end

  context 'being not an author' do
    it { is_expected.to permit_actions([:index, :show, :vote]) }
    it { is_expected.to forbid_actions([:destroy, :set_as_best]) }
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  # permissions :set_as_best? do
  #   subject { described_class }

  #   it('allow Question\'s author') do
  #     is_expected.to permit(user, create(:answer, question: create(:question, user: user)))
  #   end
  # end
  context "being an author answer's question " do
    subject { AnswerPolicy.new(question.user, answer) }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question }

    it { is_expected.to permit_action(:set_as_best) }
    # it { is_expected.to forbid_action([:vote_up, :vote_down, :vote_cancel, :set_as_best]) }
    # it { is_expected.to permit_new_and_create_actions }
    # it { is_expected.to permit_edit_and_update_actions }
  end
end
