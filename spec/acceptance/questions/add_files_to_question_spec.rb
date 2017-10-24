require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
  } do
    given(:user) { create(:user) }

    before do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User can add files when ask question' do
      fill_in 'Title', with: 'TitleText'
      fill_in 'Body', with: 'BodyText'

      within ('.nested-fields') do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
