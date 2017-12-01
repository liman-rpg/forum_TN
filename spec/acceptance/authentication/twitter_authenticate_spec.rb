require 'acceptance_helper'
require 'capybara/email/rspec'

feature 'User can sign in through Twitter', %q{
  In order to be able to enjoy the full-service site
  As an client
  I want to be able to sign in
} do

  describe "access top page" do
    it "can sign in user with Twitter account" do
      visit new_user_registration_path
      expect(page).to have_content("Sign in with Twitter")
      mock_auth_hash(:twitter, email = nil)
      clear_emails

      click_link "Sign in with Twitter"
      expect(page).to have_content("Please, enter email:")
      fill_in 'Email', with: 'test@test.com'
      click_on 'Send email'
      expect(page).to have_content("A message has been sent to your mail with a link to the confirmation mail.")

      open_email('test@test.com')
      current_email.click_link 'Confirm my email'
      expect(page).to have_content("Successfully authenticated from Twitter account.")

      expect(page).to have_content 'Log out'

      click_on 'Log out'

      expect(page).to have_content 'Signed out successfully.'

      click_on 'Sign in'
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Log out'
    end

    it "can handle authentication error" do
      visit new_user_registration_path
      expect(page).to have_content("Sign in with Twitter")
      mock_auth_invalid_hash(:twitter)

      click_link "Sign in with Twitter"

      expect(page).to have_content('Could not authenticate you from Twitter because "Invalid credentials".')
    end
  end
end
