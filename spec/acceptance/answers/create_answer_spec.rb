require 'acceptance_helper'

feature 'Create answer', %q{
  In order to get answer from questions
  Authenticate user
  I want to create answer
} do
  given(:question) { create(:question) }
  given(:user)     { create(:user) }

  describe 'Authenticate user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try create answer' do
      fill_in 'Body Answer', with: 'BodyTestAnswer'
      click_on 'Create Answer'

      expect(page).to have_content 'BodyTestAnswer'
      expect(page).to have_content 'Body Answer'
      expect(current_path).to eq question_path(question)
    end

    scenario 'to create a non-valid answer' do
      fill_in 'Body Answer', with: ''
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"

      fill_in 'Body Answer', with: 'SML'
      click_on 'Create Answer'

      expect(page).to have_content "Body is too short (minimum is 5 characters)"
    end
  end

  scenario 'Unauthenticate user try create answer' do
    visit question_path(question)

    expect(page).to_not have_selector 'textarea#answer_body'
  end

  context "multiple sessions", js: true do
    scenario "all users see new answer in real-time" do
      Capybara.using_session("author") do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session("guest") do
        visit question_path(question)
      end

      Capybara.using_session("author") do
        fill_in 'Body Answer', with: 'BodyTestAnswer'
        click_on 'Create Answer'

        expect(page).to have_content 'BodyTestAnswer'
      end

      Capybara.using_session("guest") do
        expect(page).to have_content 'BodyTestAnswer'
      end
    end
  end
end
