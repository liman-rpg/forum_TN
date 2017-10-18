require 'acceptance_helper'

feature 'Edit question', %q{
  In order to edit bad a question
  As a author question
  I want to change a question
} do
  given(:user)           { create(:user) }
  given(:question)       { create(:question, user: user) }
  given(:other_question) { create(:question) }

  describe 'The authenticating user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "edit his question" do
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

    scenario "sees link to edit" do
      within('.question .links') do
        expect(page).to have_link 'Edit'
      end
    end

    scenario "edit the question of another user" do
      visit question_path(other_question)

      within('.question') do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'sees validation errors' do
      within('.question') do
        click_on 'Edit'

        fill_in 'Title', with: nil
        fill_in 'Body', with: nil

        click_on 'Update'
      end

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Body is too short (minimum is 5 characters)"
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  describe 'Not an authenticating user' do
    before do
      visit question_path(question)
    end

    scenario "don't sees link to edit" do
      within('.question') do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
