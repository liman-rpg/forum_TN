require 'rails_helper'

feature 'Show question with answers', %q{
  The user can view a question with answers
  As a user or a guest
  The client can see a question and answers
} do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Show question #show' do
    visit root_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
    expect(current_path).to eq question_path(question)
  end
end
