require 'spec_helper'

feature 'placing ships' do

  scenario 'it has a button to place ships' do
    visit '/start?name=massi'
    click_button('Place ships')
    expect(page).to have_content 'Place your ships, Admiral massi'
  end

  scenario 'filling out a form to place ships' do
    visit '/place_ships'
    select 'cruiser', from: 'ship_type'
    select 'A', from: 'x_coord'
    select 3, from: 'y_coord'
    select 'horizontally', from: 'orientation'
    click_button('Place')
    expect(page).to have_content '3|CCC'
  end

  scenario 'you cannot choose the same ship more than once' do
    visit '/place_ships'
    select 'cruiser', from: 'ship_type'
    select 'A', from: 'x_coord'
    select 1, from: 'y_coord'
    select 'horizontally', from: 'orientation'
    click_button('Place')
    expect(page).to_not have_content 'cruiser'
  end

  scenario "you can't place a ship on top of another ship" do
    visit '/place_ships'

    select 'cruiser', from: 'ship_type'
    select 'A', from: 'x_coord'
    select 1, from: 'y_coord'
    select 'horizontally', from: 'orientation'
    click_button('Place')

    select 'cruiser', from: 'ship_type'
    select 'A', from: 'x_coord'
    select 1, from: 'y_coord'
    select 'horizontally', from: 'orientation'
    click_button('Place')


    expect(page).to have_content 'Coordinate already occupied'

  end

end
