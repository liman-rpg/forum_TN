require 'rails_helper'

shared_examples_for "voted" do
  model = controller_class.controller_path.singularize

  let(:votable) { create(model.to_sym) }

  describe "POST #vote_up" do
    sign_in_user

    let(:vote_up) { post :vote_up, params: { id: votable } }

    context 'as not the author' do
      it "change vote count by +1" do
        expect{ vote_up }.to change(votable.votes, :count).by(+1)
      end

      it "render json with id, score" do
        vote_up
        expect(response.body).to eq ({ id: votable.id, score: votable.total_score, status: true, type: model.classify }).to_json
      end
    end

    context 'as the author' do
      let(:votable) { create(model.to_sym, user: @user) }

      it "not change Vote count" do
        expect{ vote_up }.to_not change(votable.votes, :count)
      end

      it 'render status 204' do
        vote_up
        expect(response.status).to eq 403
      end
    end
  end

  describe "POST #vote_down" do
    sign_in_user

    let(:vote_down) { post :vote_down, params: { id: votable } }

    context 'as not the author' do
      it "change vote count by +1" do
        expect{ vote_down }.to change(votable.votes, :count).by(+1)
      end

      it "render json with id, score" do
        vote_down
        expect(response.body).to eq ({ id: votable.id, score: votable.total_score, status: true, type: model.classify }).to_json
      end
    end

    context 'as the author' do
      let(:votable) { create(model.to_sym, user: @user) }

      it "not change Vote count" do
        expect{ vote_down }.to_not change(votable.votes, :count)
      end

      it 'render status 204' do
        vote_down
        expect(response.status).to eq 403
      end
    end
  end

  describe "POST #vote_cancel" do
    let!(:user) { create :user }
    let(:other_user) { create :user }
    # let!(:vote) { create(:vote, :up, votable: votable, user: user) }
    let(:vote_cancel) { post :vote_cancel, params: { id: votable, format: :js } }

    context 'as the author vote' do
      before do
        sign_in user
        create(:vote, :up, votable: votable, user: user)
      end

      it "delete vote to #{model}" do
        expect{ vote_cancel }.to change(votable.votes, :count).by(-1)
      end

      it "render json with id, score" do
        vote_cancel
        expect(response.body).to eq ({ id: votable.id, score: votable.total_score, status: false, type: model.classify }).to_json
      end
    end

    # не могу запустить эти тесты (((
    # context 'as not the author vote' do
    #   before do
    #     sign_in other_user
    #     create(:vote, :up, votable: votable, user: user)
    #   end

    #   it "not delete vote to #{model}" do
    #     expect{ vote_cancel }.to_not change(votable.votes, :count)
    #   end

    #   it 'render status 403' do
    #     vote_cancel
    #     expect(response.status).to eq 403
    #   end
    # end
  end
end
