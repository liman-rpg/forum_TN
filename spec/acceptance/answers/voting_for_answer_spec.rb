require 'acceptance_helper'

feature 'User can vote', %q{
  In order mark a worthy answer
  As not the author of the answer
  I'd like to be able to vote
  } do
  given(:author)       { create(:user) }
  given(:other_user)   { create(:user) }
  given(:question)     { create(:question) }
  given!(:answer_one)  { create(:answer, user: author, question: question) }
  given!(:answer_two)  { create(:answer, user: author, question: question) }

  describe "Authenticate user & not the author of the answer" do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario "sees link to vote" do
      within(".answers div#answer-id-#{answer_one.id} .voting") do
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
        expect(page).to_not have_link 'Cancel'
      end
    end

    scenario "can vote for the answer", js: true do
      within("#answer-id-#{answer_one.id} .voting") do
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

    scenario "links changes only in the selected answer", js: true do
      within("#answer-id-#{answer_one.id} .voting") do
        click_on 'Up'

        expect(page).to have_content 'Likes: 1'
      end

      within("#answer-id-#{answer_two.id} .voting") do
        expect(page).to have_content 'Likes: 0'
      end

      within("#answer-id-#{answer_one.id} .voting") do
        click_on 'Cancel'

        expect(page).to have_content 'Likes: 0'
      end

      within("#answer-id-#{answer_two.id} .voting") do
        expect(page).to have_content 'Likes: 0'
      end

      within("#answer-id-#{answer_one.id} .voting") do
        click_on 'Down'

        expect(page).to have_content 'Likes: -1'
      end

      within("#answer-id-#{answer_two.id} .voting") do
        expect(page).to have_content 'Likes: 0'
      end
    end
  end

  scenario "Authenticate user & the author of the answer can't vote for the own answer" do
    sign_in(author)
    visit question_path(question)

    within("#answer-id-#{answer_one.id} .voting") do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Cancel'
    end
  end


  scenario 'Not authenticate user can not voting' do
    visit question_path(question)

    within("#answer-id-#{answer_one.id} .voting") do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Cancel'
    end
  end
end
