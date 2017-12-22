require 'rails_helper'

describe 'Answers Api' do
  let(:user)         { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET #show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:answer)     { create(:answer, :with_attachment) }
      let!(:comments)  { create_list(:comment, 3, commentable: answer) }
      let(:comment)    { comments.last }
      let(:attachment) { answer.attachments.first }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'returns list comments' do
          expect(response.body).to have_json_size(3).at_path('answer/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'returns list comments' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'answer object contain id' do
          expect(response.body).to be_json_eql(attachment.id.to_json).at_path("answer/attachments/0/id")
        end

        it 'answer object contain url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end
    end

    def do_request(option = {})
      get "/api/v1/answers/1", params: { format: :json }.merge(option)
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:answer)   { create(:answer, question: question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:answer_last) { Answer.last }

      context 'with valid attributes' do
        let(:create_valid_answer) { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, answer: attributes_for(:answer) } }

        it 'save answer in database' do
          expect { create_valid_answer }.to change(Answer, :count).by(+1)
        end

        context 'after create' do
          before { create_valid_answer }

          it 'returns 201 status' do
            expect(response).to be_success
          end

          %w(id body created_at updated_at).each do |attr|
            it "contains #{ attr }" do
              expect(response.body).to be_json_eql(answer_last.send(attr.to_sym).to_json).at_path("answer/#{ attr }")
            end
          end

          it 'check attributes' do
            answer_last.reload

            expect(answer_last.body).to eq "Rspec Body Answer"
            expect(answer_last.user_id).to eq user.id
          end
        end
      end

      context 'with invalid attributes' do
        let(:create_invalid_answer) { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer) } }

        it 'do not save answer in database' do
          expect { create_invalid_answer }.to_not change(Answer, :count)
        end

        it 'returns 422 status' do
          create_invalid_answer
          expect(response.status).to eq 422
        end
      end
    end

    def do_request(option = {})
      post "/api/v1/questions/1/answers", params: { format: :json }.merge(option)
    end
  end
end
