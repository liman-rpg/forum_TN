require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) }

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

    context 'with valid attributes' do
      let(:update_valid_question) { post :update, params: { id: question.id, question: attributes_for(:question), format: :js } }

      it 'assigns request the question to @question' do
        update_valid_question
        expect(assigns(:question)).to eq question
      end

      it "update question's params in database" do
        post :update, params: { id: question.id, question: { title: 'New Title', body: 'New Body'}, format: :js }
        question.reload
        expect(question.title).to eq "New Title"
        expect(question.body).to eq "New Body"
      end

      it 'render update.js' do
        update_valid_question
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:update_invalid_question) { post :update, params: { id: question.id, question: attributes_for(:invalid_question), format: :js } }
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
end
