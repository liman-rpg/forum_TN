require 'acceptance_helper'

feature 'Edit answer', %q{
  In order to edit bad a answer
  As a author answer
  I want to change a answer
} do
  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given(:answer)   { create(:answer, question: question, user: user) }

  describe 'The authenticating user' do
    before do
      sign_in(user)
      answer
      visit question_path(question)
    end

    scenario "sees link to edit" do
      within('.answers .answer .links') do
        expect(page).to have_link 'Edit'
      end
    end

    scenario "edit his answer"
    scenario 'sees validation errors'
  end

  scenario "The authenticating user edit the answer of another user" do
    sign_in(user)
    create(:answer, question: question)
    visit question_path(question)

    within('.answers .answer') do
      expect(page).to have_content 'Rspec Body Answer'
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Not an authenticating user' do
    scenario "don't sees link to edit" do
      visit question_path(question)
      within('.answers') do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
