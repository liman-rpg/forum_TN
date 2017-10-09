require 'acceptance_helper'

feature 'Delete question', %q{
  In order to remove bad a question
  As a author question
  I want to delete question
} do
  given(:author)       { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question)    { create(:question, user: author) }

  scenario "Authenticate user try delete him question" do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content "Your question successfully destroy."
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(current_path).to eq questions_path
  end

  scenario "Authenticate user try delete not him question" do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'non-authenticated user try delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end
