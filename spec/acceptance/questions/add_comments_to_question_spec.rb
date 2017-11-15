require 'acceptance_helper'

feature 'Create comment to question', %q{
  In order to clarification my question
  As an user
  I'd like to be able to commenting
  } do
  given(:user)      { create(:user) }
  given(:question)  { create(:question) }
  given!(:comment1) { create(:comment, body: 'CommentBody1', commentable: question) }
  given!(:comment2) { create(:comment, body: 'CommentBody2', commentable: question) }

  context 'Authenticate User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create comment', js: true do
      within '.question .comments .form' do
        click_on 'Add Comment'
        fill_in 'Body', with: 'NewCommentBody'
        click_on 'Create Comment'
      end

      within '.question .comments .list' do
        expect(page).to have_content 'NewCommentBody'
      end
    end

    scenario 'can see comments list' do
      within '.question .comments .list' do
        expect(page).to have_content 'CommentBody1'
        expect(page).to have_content 'CommentBody2'
      end
    end

    scenario 'can see error message', js: true do
      within '.question .comments .form' do
        click_on 'Add Comment'
        fill_in 'Body', with: nil
        click_on 'Create Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'A quest can see comments list' do
    visit question_path(question)

    within '.question .comments .list' do
      expect(page).to have_content 'CommentBody1'
      expect(page).to have_content 'CommentBody2'
    end
  end

  scenario "Not Authenticate user can not commenting" do
    visit question_path(question)

    within '.question .comments' do
      expect(page).to_not have_link 'Add Comment'
    end
  end
end
