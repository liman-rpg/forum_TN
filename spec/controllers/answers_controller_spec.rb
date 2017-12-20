require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let(:user)     { create(:user) }
  let(:question) { create(:question) }
  let(:answer)   { create(:answer) }

  describe "GET #edit" do
    sign_in_user
    before { get :edit, params: { id: answer.id } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe "POST #create" do
    sign_in_user

    context 'format JS' do
      context 'with valid attributes' do
        let(:create_valid_answer) { post :create, params: { answer: attributes_for(:answer), question_id: question.id, format: :js} }

        it "save new answer in database" do
          expect{ create_valid_answer }.to change(question.answers, :count).by(+1)
        end

        it "associated with the user" do
          expect { create_valid_answer }.to change(@user.answers, :count).by(+1)
        end
      end

      context 'with invalid attributes' do
        let(:create_invalid_answer) { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id, format: :js } }

        it "don't save new question in database" do
          expect{ create_invalid_answer }.to_not change(Answer, :count)
        end

        it "not associated with the user" do
          expect { create_invalid_answer }.to_not change(@user.answers, :count)
        end
      end
    end

    context 'format JSON' do
      context 'with valid attributes' do
        let(:create_valid_answer) { post :create, params: { answer: attributes_for(:answer), question_id: question.id, format: :json} }

        it "save new answer in database" do
          expect{ create_valid_answer }.to change(question.answers, :count).by(+1)
        end

        it "associated with the user" do
          expect { create_valid_answer }.to change(@user.answers, :count).by(+1)
        end

        it 'serves JSON with correct name field' do
          create_valid_answer

          expect(JSON.parse(response.body)['answer']['body']).to eq("Rspec Body Answer")
        end
      end

      context 'with invalid attributes' do
        let(:create_invalid_answer) { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question.id, format: :json } }

        it "don't save new question in database" do
          expect{ create_invalid_answer }.to_not change(Answer, :count)
        end

        it "not associated with the user" do
          expect { create_invalid_answer }.to_not change(@user.answers, :count)
        end
      end
    end
  end

  describe "POST #update" do
    sign_in_user

    context 'The author' do
      let(:answer) {create(:answer, user: @user) }

      context 'with valid attributes' do
        let(:update_valid_answer) { post :update, params: { id: answer.id, answer: { body: 'New Body'}, format: :js } }

        before { update_valid_answer }

        it 'assigns request the answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it "update answer's params in database" do
          answer.reload
          expect(answer.body).to eq "New Body"
        end
      end

      context 'with invalid attributes' do
        let(:update_invalid_answer) { post :update, params: { id: answer.id, answer: attributes_for(:invalid_answer), format: :js } }

        before { update_invalid_answer }

        it "don't update answer's params in database" do
          answer.reload
          expect(answer.body).to eq "Rspec Body Answer"
        end
      end
    end

    context 'Not the author' do
      let(:update_valid_answer) { post :update, params: { id: answer.id, answer: { body: 'New Body'}, format: :js } }

      before { update_valid_answer }

      it "don't update answer's params in database" do
        answer.reload
        expect(answer.body).to eq "Rspec Body Answer"
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user
    let(:delete_answer) { delete :destroy, params: { id: answer.id, format: :js } }

    context 'author' do
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'delete answer from database' do
        answer
        expect{ delete_answer }.to change(Answer, :count).by(-1)
      end
    end

    context 'not author' do
      it 'does not remove a answer from the database' do
        answer
        expect{ delete_answer }.to_not change(Answer, :count)
      end
    end
  end

  describe "POST #set_as_best" do
    sign_in_user
    let(:question)          { create(:question, user: @user) }
    let(:answer)            { create(:answer, question: question, best: false) }
    let(:patch_best_answer) { patch :set_as_best, params: { id: answer.id, question_id: question, format: :js } }

    it 'assigns answer to best to @answer' do
      patch_best_answer
      answer.reload

      expect(assigns(:answer)).to eq answer
    end

    context 'author question' do
      it 'sets best flag for selected answer' do
        patch_best_answer
        answer.reload

        expect(answer.best).to eq true
      end

      it 'cleans best flag for previously best answer' do
        best_answer = create(:answer, question: question, best: true)

        patch_best_answer
        answer.reload
        best_answer.reload

        expect(best_answer.best).to eq false
      end

      it 'renders #set_as_best partial' do
        patch_best_answer
        expect(response).to render_template :set_as_best
      end
    end

    context "not author question" do
      before do
        alt_user = create(:user)
        alt_question = create(:question, user: alt_user)
        @alt_answer = create(:answer, question: alt_question, user: user, best: false)
        @alt_best_answer = create(:answer, question: alt_question, user: user, best: true)
        patch :set_as_best, params: { id: @alt_answer, question_id: alt_question, format: :js }
      end

      it "doesn't sets best flag for selected answer" do
        expect(@alt_answer.best).to eq false
      end

      it 'keeps best flag for already best answer' do
        expect(@alt_best_answer.best).to eq true
      end
    end
  end
end
