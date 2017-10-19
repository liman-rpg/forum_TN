require 'acceptance_helper'

feature 'Set best answer', %q{
  In order to mark the best answer
  As a author question
  I want to set best answer
} do
  given(:user)        { create(:user) }
  given(:other_user)  { create(:user) }
  given(:question)    { create(:question, user: user) }
  given!(:answer_one) { create(:answer, question: question, best: false) }
  given!(:answer_two) { create(:answer, question: question, best: false) }

  describe 'The authenticating user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'the author of the question sees links' do
      within("#answer-id-#{answer_one.id}") do
        expect(page).to have_link 'Set as best'
      end

      within("#answer-id-#{answer_two.id}") do
        expect(page).to have_link 'Set as best'
      end
    end

    scenario 'the author of the question to mark the best answer' do
      within("#answer-id-#{answer_one.id}") do
        click_on 'Set as best'
      end

      within("#answer-id-#{answer_one.id}") do
        expect(page).to_not have_link 'Set as best'
        expect(page).to have_content 'The Best Answer'
      end

      within("#answer-id-#{answer_two.id}") do
        expect(page).to have_link 'Set as best'
        expect(page).to_not have_content 'The Best Answer'

        click_on 'Set as best'
      end

      within("#answer-id-#{answer_two.id}") do
        expect(page).to_not have_link 'Set as best'
        expect(page).to have_content 'The Best Answer'
      end

      within("#answer-id-#{answer_one.id}") do
        expect(page).to have_link 'Set as best'
        expect(page).to_not have_content 'The Best Answer'
      end
    end
  end

  scenario 'The authenticating user and not the author of the question does not see the link' do
    sign_in(other_user)
    visit question_path(question)

    within('.answers') do

      expect(page).to_not have_link 'Set as best'
    end
  end

  scenario "A guest does not see link" do
    visit question_path(question)

    within('.answers') do
      expect(page).to_not have_link 'Set as best'
    end
  end
end
