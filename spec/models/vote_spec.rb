require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :score }
  it { should validate_inclusion_of(:score).in_range(-1..1) }

  describe "uniqueness" do
    let!(:question) { create(:question) }
    let!(:vote)     { create(:vote, votable: question) }

    it { should validate_uniqueness_of(:votable_id).scoped_to([:votable_type, :user_id]) }
  end
end
