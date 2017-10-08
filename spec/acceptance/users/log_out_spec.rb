require 'acceptance_helper'

feature 'User can log_out', %q{
  In order to interact with community
  As an User
  I want to log_out
  } do
    given(:user) { create(:user) }

    scenario 'User sign_out' do
      sign_in(user)

      click_on 'Log out'

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq root_path
    end
  end
