shared_examples_for "Vote Policy" do |object|
  context "for a visitor" do
    let(:user) { nil }

    it { is_expected.to forbid_actions([:vote, :vote_remove]) }
  end

  context "for an authorized user and not author object" do
    let(object) { create object }

    it { is_expected.to permit_action(:vote) }
    it { is_expected.to forbid_action(:vote_remove) }
  end

  context "for an authorized user and not author object, and author vote" do
    subject { QuestionPolicy.new(user, resource, vote) }
    let(:resource) { create object }
    let(:vote)     { create :vote, :up, votable: resource, user: user }

    it { is_expected.to permit_actions([:vote_remove, :vote]) }
  end
end
