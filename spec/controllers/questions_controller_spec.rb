require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array for all questions' do
      expect(assigns(:questions)).to match_array(question)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question.id } }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    sign_in_user
    before { get :edit, params: { id: question.id } }

    it 'assigns an edit Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    sign_in_user

    context 'with valid attributes' do
      let(:create_valid_question) { post :create, params: { question: attributes_for(:question) } }

      it "save new question in database" do
        expect{ create_valid_question }.to change(Question, :count).by(+1)
      end

      it "associated with the user" do
        expect { create_valid_question }.to change(@user.questions, :count).by(+1)
      end

      it 'redirects to show view' do
        create_valid_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_question) { post :create, params: { question: attributes_for(:invalid_question) } }

      it "don't save new question in database" do
        expect{ create_invalid_question }.to_not change(Question, :count)
      end

      it "not associated with the user" do
        expect { create_invalid_question }.to_not change(@user.questions, :count)
      end

      it 're-render new view' do
        create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #update" do
    sign_in_user

    let(:question)              { create(:question, user: @user) }
    let(:update_valid_question) { post :update, params: { id: question.id, user: @user, question: { title: 'New Title', body: 'New Body'}, format: :js } }

    before { update_valid_question }

    context 'with valid attributes' do
      it 'assigns request the question to @question' do
        expect(assigns(:question)).to eq question
      end

      it "update question's params in database" do
        question.reload
        expect(question.title).to eq "New Title"
        expect(question.body).to eq "New Body"
      end

      it 'render update.js' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:update_invalid_question) { post :update, params: { id: question.id, question: attributes_for(:invalid_question), user: @user, format: :js } }
      before { update_invalid_question }

      it "don't update question's params in database" do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'render update.js' do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user
    let(:delete_question) { delete :destroy, params: { id: question.id } }

    context 'author' do
      let(:question) { Question.create!(title: 'ExampleTitle', body: 'ExampleBody', user_id: @user.id) }

      it 'delete question from database' do
        question
        expect{ delete_question }.to change(Question, :count).by(-1)
      end

      it 'redirects to root_path' do
        delete_question
        expect(response).to redirect_to questions_path
        expect(flash[:notice]).to be_present
      end
    end

    context 'not author' do
      it 'does not remove a question from the database' do
        question
        expect{ delete_question }.to_not change(Question, :count)
      end

      it "redirects to root_path" do
        delete_question
        expect(response).to redirect_to questions_path
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "POST #vote_up" do
    sign_in_user

    let(:vote_up) { post :vote_up, params: { id: question } }

    context 'as not the author' do
      it "change vote count by +1" do
        expect{ vote_up }.to change(question.votes, :count).by(+1)
      end

      it "render json with id, score" do
        vote_up
        expect(response.body).to eq ({ id: question.id, score: question.total_score }).to_json
      end
    end

    context 'as the author' do
      let(:question) { create(:question, user: @user) }

      it "not change Vote count" do
        expect{ vote_up }.to_not change(question.votes, :count)
      end

      it 'render status 204' do
        vote_up
        expect(response.status).to eq(204)
      end
    end
  end

  describe "POST #vote_down" do
    sign_in_user

    let(:vote_down) { post :vote_down, params: { id: question } }

    context 'as not the author' do
      it "change vote count by +1" do
        expect{ vote_down }.to change(question.votes, :count).by(+1)
      end

      it "render json with id, score" do
        vote_down
        expect(response.body).to eq ({ id: question.id, score: question.total_score }).to_json
      end
    end

    context 'as the author' do
      let(:question) { create(:question, user: @user) }

      it "not change Vote count" do
        expect{ vote_down }.to_not change(question.votes, :count)
      end

      it 'render status 204' do
        vote_down
        expect(response.status).to eq(204)
      end
    end
  end

  describe "POST #vote_cancel" do
    sign_in_user

    before { post :vote_cancel, params: { id: question } }

    context 'as not the author' do
      it "delete vote" do
        expect(question.votes.count).to eq 0
      end

      it "render json with id, score" do
        expect(response.body).to eq ({ id: question.id, score: question.total_score }).to_json
      end
    end

    context 'as the author' do
      let(:question) { create(:question, user: @user) }

      it "not change Vote count" do
        expect(question.votes.count).to eq 0
      end

      it 'render status 204' do
        expect(response.status).to eq(204)
      end
    end
  end
end
