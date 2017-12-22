require 'rails_helper'

describe 'Questions Api' do
  describe 'GET #index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions)   { create_list(:question, 3) }
      let(:question)     { questions.first }
      let!(:answer)      { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list questions' do
        expect(response.body).to have_json_size(3).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contain short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(option = {})
      get '/api/v1/questions', params: { format: :json }.merge(option)
    end
  end

  describe 'GET #show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question)    { create(:question, :with_attachment) }
      let!(:comments)    { create_list(:comment, 3, commentable: question) }
      let(:comment)      { comments.last }
      let(:attachment)   { question.attachments.first }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'returns list comments' do
          expect(response.body).to have_json_size(3).at_path('question/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'returns list comments' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'question object contain id' do
          expect(response.body).to be_json_eql(attachment.id.to_json).at_path("question/attachments/0/id")
        end

        it 'question object contain url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end

    def do_request(option = {})
      get "/api/v1/questions/1", params: { format: :json }.merge(option)
    end
  end

  describe 'GET #answers' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question)    { create(:question) }
      let!(:answers)     { create_list(:answer, 3, question: question) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list anwers' do
        expect(response.body).to have_json_size(3).at_path("answers")
      end
    end

    def do_request(option = {})
      get "/api/v1/questions/1/answers", params: { format: :json }.merge(option)
    end
  end

  describe 'POST #create' do
    let(:user)         { create(:user) }
    let(:question)     { create(:question) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:question_last) { Question.last }

      context 'with valid attributes' do
        let(:create_valid_question) { post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: attributes_for(:question) } }

        it 'save question in database' do
          expect { create_valid_question }.to change(Question, :count).by(+1)
        end

        context 'after create' do
          before { create_valid_question }

          it 'returns 201 status' do
            expect(response).to be_success
          end

          %w(id title body created_at updated_at).each do |attr|
            it "contains #{ attr }" do
              expect(response.body).to be_json_eql(question_last.send(attr.to_sym).to_json).at_path("question/#{ attr }")
            end
          end

          it 'check attributes' do
            question_last.reload

            expect(question_last.title).to eq question_last[:title]
            expect(question_last.body).to eq "RspecQuestionBody"
            expect(question_last.user_id).to eq user.id
          end
        end
      end

      context 'with invalid attributes' do
        let(:create_invalid_question) { post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: attributes_for(:invalid_question) } }

        it 'do not save question in database' do
          expect { create_invalid_question }.to_not change(Question, :count)
        end

        it 'returns 422 status' do
          create_invalid_question
          expect(response.status).to eq 422
        end
      end
    end

    def do_request(option = {})
      post "/api/v1/questions/", params: { format: :json }.merge(option)
    end
  end
end
