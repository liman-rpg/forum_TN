require 'acceptance_helper'

feature 'Create question', %q{
  In order to ask a question
  As a authenticate user
  I want to create question
} do
  given(:user) { create(:user) }

  scenario 'User try create a question' do
    visit root_path
    sign_in(user)
    click_on "Add Question"

    fill_in 'Title', with: 'New Question Title'
    fill_in 'Body', with: 'New Question Body'
    click_on 'Create'

    expect(page).to have_content "Your question successfully created."
    expect(page).to have_content "New Question Title"
    expect(page).to have_content "New Question Body"
  end

  scenario 'Non authenticated user try create a question' do
    visit root_path

    expect(page).to_not have_content 'Add Question'
  end
end
