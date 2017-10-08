require 'acceptance_helper'

feature 'User can log_in', %q{
  In order to interact with community
  As an User
  I want to log_in
  } do
    given(:user) { create(:user) }

    scenario 'The registered user try enter' do
      sign_in(user)

      expect(page).to have_content 'Signed in successfully.'
      expect(current_path).to eq root_path
    end

    scenario 'The unregistered user try enter' do
      visit new_user_session_path
      fill_in 'Email', with: 'false@test.ru'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
      expect(current_path).to eq new_user_session_path
    end
  end
