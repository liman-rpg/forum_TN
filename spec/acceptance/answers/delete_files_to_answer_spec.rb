require 'acceptance_helper'

feature 'Delete files to answer', %q{
  In order to remove illustrate my answer
  As an answer's author
  I'd like to be able to remove files
  } do
    given(:user)        { create(:user) }
    given(:other_user)  { create(:user) }
    given(:question)    { create(:question) }
    given!(:answer)     { create(:answer, :with_attachment, question: question, user: user) }

    scenario 'Authenticate user as author the answer can delete his files', js: true do
      sign_in(user)
      visit question_path(question)

      within ("#answer-id-#{answer.id}") do
        expect(page).to have_link 'acceptance_helper.rb', href: /uploads\/attachment\/file\/\d+\/\w+_helper.rb/

        click_on 'Delete file'
      end

      expect(page).to have_content "Attachment was successfully destroyed."
      expect(page).to_not have_link 'acceptance_helper.rb', href: /uploads\/attachment\/file\/\d+\/\w+_helper.rb/
    end

    scenario 'Authenticate user as not author the answer can not delete other user files' do
      sign_in(other_user)
      visit question_path(question)

      within ("#answer-id-#{answer.id}") do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'Not authenticate user can not delete files' do
      visit question_path(question)

      within ("#answer-id-#{answer.id}") do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
