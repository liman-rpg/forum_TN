require 'rails_helper'

describe 'Answers Api' do
  describe 'GET #show' do
    context 'unauthorized' do
      let(:answer) { create(:answer) }
      it 'return 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer)       { create(:answer, :with_attachment) }
      let!(:comments)    { create_list(:comment, 3, commentable: answer) }
      let(:comment)      { comments.last }
      let(:attachment)   { answer.attachments.first }

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
  end
end
