require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer)   { create(:answer, user: user, question: question) }

  describe "GET #edit" do
    sign_in_user
    before { get :edit, params: { id: answer.id } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    sign_in_user

    context 'with valid attributes' do
      let(:create_valid_answer) { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }

      it "save new answer in database" do
        expect{ create_valid_answer }.to change(question.answers, :count).by(+1)
      end

      it "associated with the user" do
        expect { create_valid_answer }.to change(@user.answers, :count).by(+1)
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

      it "not associated with the user" do
        expect { create_invalid_answer }.to_not change(@user.answers, :count)
      end

      it 're-render question #show' do
        create_invalid_answer
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe "POST #update" do
    sign_in_user

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

    context 'author'
      before do
        user
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in(user)
      end

      it 'delete answer from database' do
        expect{ delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirect_to answers question' do
        delete_answer
        expect(response).to redirect_to question_path(answer.question)
      end

    context 'not author' do
      sign_in_user

      it 'does not remove a answer from the database' do
        expect{ delete_answer }.to_not change(Answer, :count)
      end
    end
  end
end
