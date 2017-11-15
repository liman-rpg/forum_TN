require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }

  describe "POST #create" do
    sign_in_user

    context 'with valid attributes' do
      let(:create_valid_comment) { post :create, params: { comment: attributes_for(:comment), question_id: question } }

      it "save new comment in database" do
        expect{ create_valid_comment }.to change(question.comments, :count).by(+1)
      end

      it "associated with the user" do
        expect { create_valid_comment }.to change(@user.comments, :count).by(+1)
      end

      it 'redirect to @question' do
        create_valid_comment
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_comment) { post :create, params: { comment: { body: nil }, question_id: question } }

      it "don't save new comment in database" do
        expect{ create_invalid_comment }.to_not change(Comment, :count)
      end

      it "not associated with the user" do
        expect { create_invalid_comment }.to_not change(@user.comments, :count)
      end

      it 'redirect to @question' do
        create_invalid_comment
        expect(response).to redirect_to question
      end
    end
  end
end
