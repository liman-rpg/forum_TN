require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
  } do
    given(:user)      { create(:user) }
    given!(:question) { create(:question) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can add files when ask answer', js: true do
      fill_in 'Body Answer', with: 'BodyTestAnswer'

      within('.form-attachment') do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on 'Create Answer'

      within '.answers .attachments-list' do
        expect(page).to have_link 'spec_helper.rb', href: /uploads\/attachment\/file\/\d+\/\w+_helper.rb/
        expect(page).to have_content 'spec_helper.rb'
      end
    end
  end
