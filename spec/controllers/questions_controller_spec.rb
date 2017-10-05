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
end
