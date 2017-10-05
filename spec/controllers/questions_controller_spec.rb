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
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before { get :edit, params: { id: question.id } }

    it 'assigns an edit Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context 'with valid attributes' do
      let(:create_valid_question) { post :create, params: { question: attributes_for(:question) } }

      it "save new question in database" do
        expect{ create_valid_question }.to change(Question, :count).by(+1)
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

      it 'redirects to show view' do
        create_invalid_question

        expect(response).to render_template :new
      end
    end
  end
end
