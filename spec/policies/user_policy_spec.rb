require 'rails_helper'

RSpec.describe UserPolicy do
  subject { UserPolicy.new(user, object) }
  let(:object) { create :user }
  let(:user)   { create :user }

  context "for a visitor" do
    let(:user) { nil }

    it { is_expected.to permit_actions([:index, :me]) }
    it { is_expected.to forbid_new_and_create_actions }
  end

  context 'authorize user' do
    let(:object) { user }

    it { is_expected.to permit_actions([:index, :me]) }
    it { is_expected.to permit_new_and_create_actions }
  end
end
