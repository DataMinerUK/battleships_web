require 'spec_helper'

feature 'in battle' do

  scenario 'after placing ships we begin' do
    visit '/start'
    fill_in 'name', with: 'Kirsten'
    click_button('Submit')
    click_button('Place ships')

    select 'cruiser', from: 'ship_type'
    select 'A', from: 'x_coord'
    select 1, from: 'y_coord'
    select 'vertically', from: 'orientation'
    click_button('Place')

    select 'submarine', from: 'ship_type'
    select 'B', from: 'x_coord'
    select 1, from: 'y_coord'
    select 'vertically', from: 'orientation'
    click_button('Place')

    select 'destroyer', from: 'ship_type'
    select 'C', from: 'x_coord'
    select 1, from: 'y_coord'
    select 'vertically', from: 'orientation'
    click_button('Place')

    select 'battleship', from: 'ship_type'
    select 'D', from: 'x_coord'
    select 1, from: 'y_coord'
    select 'vertically', from: 'orientation'
    click_button('Place')

    select 'aircraft carrier', from: 'ship_type'
    select 'E', from: 'x_coord'
    select 1, from: 'y_coord'
    select 'vertically', from: 'orientation'
    click_button('Place')

    expect(page).to have_content "Fire at your opponent's board"
  end




end
