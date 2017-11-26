require 'acceptance_helper'

feature 'User can sign in through Facebook', %q{
  In order to be able to enjoy the full-service site
  As an client
  I want to be able to sign in
} do

  describe "access top page" do
    it "can sign in user with Facebook account" do
      visit new_user_registration_path
      expect(page).to have_content("Sign in with Facebook")
      mock_auth_hash(:facebook)

      click_link "Sign in with Facebook"

      expect(page).to have_content("mockuser")
      expect(page).to have_content("Log out")
      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end

    it "can handle authentication error" do
      visit new_user_registration_path
      expect(page).to have_content("Sign in with Facebook")
      mock_auth_invalid_hash(:facebook)

      click_link "Sign in with Facebook"

      expect(page).to have_content('Could not authenticate you from Facebook because "Invalid credentials".')
    end
  end
end
