require 'acceptance_helper'

feature 'Edit question', %q{
  In order to edit bad a question
  As a author question
  I want to change a question
} do
  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'The authenticating user', js: true do
    scenario "edit his question" do
      sign_in(user)
      visit question_path(question)

      within('.question') do
        click_on 'Edit'

        fill_in 'Title', with: 'New Question Title'
        fill_in 'Body', with: 'New Question Body'

        click_on 'Update'
      end

      expect(page).to have_content "Your question was successfully updated."
      expect(page).to have_content 'New Question Title'
      expect(page).to have_content 'New Question Body'
      expect(page).to_not have_content question.body
      expect(page).to_not have_content question.title
      expect(page).to_not have_selector 'input#question_title'
      expect(page).to_not have_selector 'textarea#question_body'
      expect(current_path).to eq question_path(question)

      within('.question') do
        click_on 'Edit'

        fill_in 'Title', with: 'Other Question Title'
        fill_in 'Body', with: 'Other Question Body'

        click_on 'Update'
      end

      expect(page).to have_content "Your question was successfully updated."
      expect(page).to have_content 'Other Question Title'
      expect(page).to have_content 'Other Question Body'
      expect(page).to_not have_content 'New Question Title'
      expect(page).to_not have_content 'New Question Body'
      expect(page).to_not have_selector 'input#question_title'
      expect(page).to_not have_selector 'textarea#question_body'
      expect(current_path).to eq question_path(question)
    end

    scenario "sees link to edit"
    scenario "edit the question of another user"
  end
  describe 'Not an authenticating user' do
    scenario "try edit the question of another user"
  end
end
