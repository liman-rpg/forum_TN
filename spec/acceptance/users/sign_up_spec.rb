require 'rails_helper'

feature 'User sign_up', %q{
  In order to interact with community
  As an User
  I want to sign_up
} do
  scenario 'Sign up' do
    visit new_user_registration_path
    fill_in 'Name', with: 'New Name'
    fill_in 'Email', with: 'test@test.ru'
    find('div.input.password.required.user_password.field_with_hint').fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
