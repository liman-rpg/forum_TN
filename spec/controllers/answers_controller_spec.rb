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

  describe "POST #update" do
    context 'with valid attributes' do
      let(:update_valid_answer) { post :update, params: { id: answer.id, answer: attributes_for(:answer), question_id: question.id } }

      it 'assigns request the answer to @answer' do
        update_valid_answer
        expect(assigns(:answer)).to eq answer
      end

      it "update answer's params in database" do
        post :update, params: { id: answer.id, answer: { body: 'New Body'} }
        answer.reload
        expect(answer.body).to eq "New Body"
      end

      it 'redirect to answers question' do
        update_valid_answer
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      let(:update_invalid_answer) { post :update, params: { id: answer.id, answer: attributes_for(:invalid_answer) } }

      before { update_invalid_answer }

      it "don't update answer's params in database" do
        answer.reload
        expect(answer.body).to eq "Rspec Body Answer"
      end

      it 're-renders :edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before { answer }
    let(:delete_answer) { delete :destroy, params: { id: answer.id } }

    it 'delete answer from database' do
      expect{ delete_answer }.to change(Answer, :count).by(-1)
    end

    it 'redirect_to answers question' do
      delete_answer
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
