require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { CommentPolicy.new(user, object) }
  let(:user)     { create :user }


  context 'question' do
    let(:object) { create :question }

    context "for a visitor" do
      let(:user) { nil }

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_action(:create) }
    end

    context 'being an user, for question' do
      let(:object) { create :question, user: user }

      it { is_expected.to permit_actions([:show, :create]) }
    end
  end

  context 'question' do
    let(:object) { create :answer }

    context "for a visitor" do
      let(:user) { nil }

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_action(:create) }
    end

    context 'being an user, for question' do
      let(:object) { create :answer, user: user }

      it { is_expected.to permit_actions([:show, :create]) }
    end
  end
end
