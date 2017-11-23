require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe "DELETE #destroy" do
    let(:delete_question_attachment) { delete :destroy, params: { id: question.attachments.first, format: :js } }
    let(:delete_answer_attachment)   { delete :destroy, params: { id: answer.attachments.first, format: :js } }

    sign_in_user

    context 'by the author of question' do
      let(:question) { create(:question, :with_attachment, user: @user) }

      it 'to delete the attachment file from database' do
        question
        expect { delete_question_attachment }.to change(question.attachments, :count).by(-1)
      end
    end

    context 'by not the author of question' do
      let(:question) { create(:question, :with_attachment) }

      it 'doesnt deletes the attachment from database' do
        question
        expect { delete_question_attachment }.to_not change(Attachment, :count)
      end
    end

    context 'by the author of answer' do
      let(:answer) { create(:answer, :with_attachment, user: @user) }

      it 'to delete the attachment file from database' do
        answer
        expect { delete_answer_attachment }.to change(answer.attachments, :count).by(-1)
      end
    end

    context 'by not the author of answer' do
      let(:answer) { create(:answer, :with_attachment) }

      it 'doesnt deletes the attachment from database' do
        answer
        expect { delete_answer_attachment }.to_not change(Attachment, :count)
      end
    end
  end
end
