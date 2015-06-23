require 'spec_helper'

feature 'placing ships' do

  scenario 'it has a button to place ships' do
    visit '/start?name=massi'
    click_button('Place ships')
    expect(page).to have_content 'Place your ships, Admiral massi'
  end

  scenario 'filling out a form to place ships' do
    visit '/place_ships'
    fill_in 'ship_type', with: 'cruiser'
    fill_in 'coordinate', with: 'A3'
    fill_in 'orientation', with: 'horizontally'
    click_button('Place')
    expect(page).to have_content '3|CCC'
  end



end
