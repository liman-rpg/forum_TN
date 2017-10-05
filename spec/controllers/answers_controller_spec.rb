require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer)   { create(:answer) }

  describe "GET #new" do
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before { get :edit, params: { id: answer.id } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context 'with valid attributes' do
      let(:create_valid_answer) { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }

      it "save new answer in database" do
        expect{ create_valid_answer }.to change(question.answers, :count).by(+1)
      end

      it 'redirects to show view' do
        create_valid_answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_answer) { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id } }

      it "don't save new question in database" do
        expect{ create_invalid_answer }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        create_invalid_answer
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #update"
  describe "DELETE #destroy"
end
