require 'acceptance_helper'

feature 'Set best answer', %q{
  In order to mark the best answer
  As a author question
  I want to set best answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given(:question)   { create(:question, user: user) }
  given!(:answer)    { create(:answer, question: question) }

  describe 'The authenticating user' do
    scenario 'the author of the question sees link' do
      sign_in(user)
      visit question_path(question)

      within('.answers .answer .best-group') do
        expect(page).to have_link 'Set as best'
      end
    end

    scenario 'not the author of the question does not see the link' do
      sign_in(other_user)
      visit question_path(question)

      within('.answers .answer') do
        expect(page).to_not have_link 'Set as best'
      end
    end
  end

  scenario "A guest does not see link" do
    visit question_path(question)

    within('.answers .answer') do
      expect(page).to_not have_link 'Set as best'
    end
  end
end
