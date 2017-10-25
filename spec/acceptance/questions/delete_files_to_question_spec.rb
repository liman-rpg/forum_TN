require 'acceptance_helper'

feature 'Delete files to question', %q{
  In order to remove illustrate my question
  As an question's author
  I'd like to be able to remove files
  } do
    given(:user)           { create(:user) }
    given(:question)       { create(:question, :with_attachment, user: user) }
    given(:other_question) { create(:question, :with_attachment) }

    describe 'Authenticate user' do
      before do
        sign_in(user)
      end

      scenario 'as author the question can delete his files', js: true do
        visit question_path(question)

        expect(page).to have_link 'acceptance_helper.rb', href: /uploads\/attachment\/file\/\d+\/\w+_helper.rb/

        within ('.attachments-list') do
          click_on 'Delete file'
        end

        expect(page).to have_content "Your attachment was successfully destroy."
        expect(page).to_not have_link 'acceptance_helper.rb', href: /uploads\/attachment\/file\/\d+\/\w+_helper.rb/
      end

      scenario 'as not author the questioncan not delete other user files' do
        visit question_path(other_question)

        within ('.attachments-list') do
          expect(page).to_not have_link 'Delete file'
        end
      end
    end

    scenario 'Not authenticate user can not delete files' do
      visit question_path(question)

      within ('.attachments-list') do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
