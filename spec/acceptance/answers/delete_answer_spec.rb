require 'acceptance_helper'

feature 'Delete answer', %q{
  In order to remove bad a answer
  As a author
  I want to delete answer
} do
  given(:author)       { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question)    { create(:question, user: author) }
  given!(:answer)      { create(:answer, question: question, user: author) }

  scenario 'Authenticate user try delete him answer', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete Answer'

    expect(page).to have_content 'Answer was successfully destroyed.'
    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario "Aauthenticate user try delete not him answer" do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end

  scenario 'non-authenticated user try delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end
end
