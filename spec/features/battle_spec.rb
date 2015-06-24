require 'spec_helper'

feature 'in battle' do

  scenario 'after placing ships we begin' do
    visit '/place_ships'
    click_button('Battle!')
    expect(page).to have_content "Let's start the battle"
  end




end