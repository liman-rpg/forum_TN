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

    it 'render edit view' do
      expect(response).to render_template :edit
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

        it 'render template create.js' do
          create_valid_answer

          expect(response).to render_template :create
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

        it 'render template create.js' do
          create_invalid_answer

          expect(response).to render_template :create
        end
      end
    end

    context 'format JS' do
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

          expect(JSON.parse(response.body)['body']).to eq("Rspec Body Answer")
        end

        it 'response status OK' do
          create_valid_answer

          expect(response.status).to eq 200
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

        it 'render answer.errors' do
          create_invalid_answer

          expect(JSON.parse(response.body)[0]).to eq("Body is too short (minimum is 5 characters)")
          expect(JSON.parse(response.body)[1]).to eq("Body can't be blank")
        end

        it 'response status unprocessable_entity' do
          create_invalid_answer

          expect(response.status).to eq 422
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

        it 'render update.js' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:update_invalid_answer) { post :update, params: { id: answer.id, answer: attributes_for(:invalid_answer), format: :js } }

        before { update_invalid_answer }

        it "don't update answer's params in database" do
          answer.reload
          expect(answer.body).to eq "Rspec Body Answer"
        end

        it 'render update.js' do
          expect(response).to render_template :update
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

      it 'render update.js' do
        expect(response).to render_template :update
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

      it 'render destroy.js' do
        delete_answer
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      it 'does not remove a answer from the database' do
        answer
        expect{ delete_answer }.to_not change(Answer, :count)
      end

      it 'render destroy.js' do
        delete_answer
        expect(response).to render_template :destroy
      end
    end
  end

  describe "POST #set_as_best" do
    sign_in_user
    let!(:question) { create(:question, user: @user) }
    let!(:answer)   { create(:answer, question: question, best: false) }

    it "change the answer :best from false to true" do
      expect{ answer.set_as_best }.to change(answer, :best).to(true)
    end
  end
end
