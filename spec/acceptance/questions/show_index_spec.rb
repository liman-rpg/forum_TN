require 'acceptance_helper'

feature 'Show questions_path page', %q{
  The user can view a list of questions,
  As a user or a guest,
  The client can see questions list
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'Show #index' do
    visit questions_path

    expect(page).to have_content 'Questions list:'
    expect(page).to have_link 'RspecQuestionTitle1'
    expect(page).to have_link 'RspecQuestionTitle2'
    expect(page).to have_link 'RspecQuestionTitle3'
    expect(current_path).to eq questions_path
  end
end
