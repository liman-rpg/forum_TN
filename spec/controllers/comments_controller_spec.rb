require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question)  { create(:question) }
  let(:answer)    { create(:answer) }

  describe "POST #create" do
    sign_in_user

    context 'format JS' do
      context "commentable 'question'" do
        context 'with valid attributes' do
          let(:create_valid_comment) { post :create, params: { comment: attributes_for(:comment), question_id: question, commentable: 'question', format: :js } }

          it "save new comment in database" do
            expect{ create_valid_comment }.to change(question.comments, :count).by(+1)
          end

          it "associated with the user" do
            expect { create_valid_comment }.to change(@user.comments, :count).by(+1)
          end

          it 'render create.js' do
            create_valid_comment
            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          let(:create_invalid_comment) { post :create, params: { comment: { body: nil }, question_id: question, commentable: 'question', format: :js } }

          it "don't save new comment in database" do
            expect{ create_invalid_comment }.to_not change(Comment, :count)
          end

          it "not associated with the user" do
            expect { create_invalid_comment }.to_not change(@user.comments, :count)
          end

          it 'render create.js' do
            create_invalid_comment
            expect(response).to render_template :create
          end
        end
      end

      context "commentable 'answer'" do
        context 'with valid attributes' do
          let(:create_valid_comment) { post :create, params: { comment: attributes_for(:comment), answer_id: answer, commentable: 'answer', format: :js } }

          it "save new comment in database" do
            expect{ create_valid_comment }.to change(answer.comments, :count).by(+1)
          end

          it "associated with the user" do
            expect { create_valid_comment }.to change(@user.comments, :count).by(+1)
          end

          it 'render create.js' do
            create_valid_comment
            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          let(:create_invalid_comment) { post :create, params: { comment: { body: nil }, answer_id: answer, commentable: 'answer', format: :js } }

          it "don't save new comment in database" do
            expect{ create_invalid_comment }.to_not change(Comment, :count)
          end

          it "not associated with the user" do
            expect { create_invalid_comment }.to_not change(@user.comments, :count)
          end

          it 'render create.js' do
            create_invalid_comment
            expect(response).to render_template :create
          end
        end
      end
    end

    context 'format JSON' do
      context "commentable 'question'" do
        context 'with valid attributes' do
          let(:create_valid_comment) { post :create, params: { comment: attributes_for(:comment), question_id: question, commentable: 'question', format: :json } }

          it "save new comment in database" do
            expect{ create_valid_comment }.to change(question.comments, :count).by(+1)
          end

          it "associated with the user" do
            expect { create_valid_comment }.to change(@user.comments, :count).by(+1)
          end

          it 'response status OK' do
            create_valid_comment

            expect(response.status).to eq 200
          end
        end

        context 'with invalid attributes' do
          let(:create_invalid_comment) { post :create, params: { comment: { body: nil }, question_id: question, commentable: 'question', format: :json } }

          it "don't save new comment in database" do
            expect{ create_invalid_comment }.to_not change(Comment, :count)
          end

          it "not associated with the user" do
            expect { create_invalid_comment }.to_not change(@user.comments, :count)
          end

          it 'response status unprocessable_entity' do
            create_invalid_comment

            expect(response.status).to eq 422
          end
        end
      end

      context "commentable 'answer'" do
        context 'with valid attributes' do
          let(:create_valid_comment) { post :create, params: { comment: attributes_for(:comment), answer_id: answer, commentable: 'answer', format: :json } }

          it "save new comment in database" do
            expect{ create_valid_comment }.to change(answer.comments, :count).by(+1)
          end

          it "associated with the user" do
            expect { create_valid_comment }.to change(@user.comments, :count).by(+1)
          end

          it 'response status OK' do
            create_valid_comment

            expect(response.status).to eq 200
          end
        end

        context 'with invalid attributes' do
          let(:create_invalid_comment) { post :create, params: { comment: { body: nil }, answer_id: answer, commentable: 'answer', format: :json } }

          it "don't save new comment in database" do
            expect{ create_invalid_comment }.to_not change(Comment, :count)
          end

          it "not associated with the user" do
            expect { create_invalid_comment }.to_not change(@user.comments, :count)
          end

          it 'response status unprocessable_entity' do
            create_invalid_comment

            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
