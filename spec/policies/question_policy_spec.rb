require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { QuestionPolicy.new(user, question) }
  let(:question) { create :question }
  let(:user)     { create :user }

  context "for a visitor" do
    let(:user) { nil }

    it { is_expected.to permit_actions([:index, :show]) }
    it { is_expected.to forbid_actions([:destroy, :vote]) }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'being an author' do
    let(:question) { create :question, user: user }

    it { is_expected.to permit_actions([:index, :show, :destroy]) }
    it { is_expected.to forbid_actions([:vote]) }
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_edit_and_update_actions }
  end

  context 'being not an author' do
    it { is_expected.to permit_actions([:index, :show, :vote]) }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
  end
end
