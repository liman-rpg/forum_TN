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

      within all('.nested-fields').first do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on 'add file'

      within all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Create Answer'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end

    scenario 'User can delete files when fill form', js: true do
      click_on 'add file'

      expect(page).to have_css(".nested-fields input", :count => 2)

      within all('.nested-fields').first do
        click_on 'remove task'
      end

      expect(page).to have_css(".nested-fields input", :count => 1)

      within all('.nested-fields').first do
        click_on 'remove task'
      end

      expect(page).to_not have_css(".nested-fields")
    end
  end
