require 'acceptance_helper'

feature 'User can vote', %q{
  In order mark a worthy question
  As not the author of the question
  I'd like to be able to vote
  } do
  given(:author)      { create(:user) }
  given(:other_user)  { create(:user) }
  given(:question)    { create(:question, user: author) }

  describe "Authenticate user & not the author of the question" do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario "sees link to vote" do
      within ".question .voting" do
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
        expect(page).to_not have_link 'Cancel'
      end
    end

    scenario "can vote for the question", js: true do
      within ".question .voting" do
        click_on 'Up'

        expect(page).to have_content 'Likes: 1'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to have_link 'Cancel'

        click_on 'Cancel'

        expect(page).to have_content 'Likes: 0'
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
        expect(page).to_not have_link 'Cancel'

        click_on 'Down'

        expect(page).to have_content 'Likes: -1'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to have_link 'Cancel'
      end
    end
  end

  scenario "Authenticate user & the author of the question can't vote for the own question" do
    sign_in(author)
    visit question_path(question)

    within ".question .voting" do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Cancel'
    end
  end


  scenario 'Not authenticate user can not voting' do
    visit question_path(question)

    within ".question .voting" do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Cancel'
    end
  end
end
