require 'launchy'
require 'spec_helper'

feature 'shotting at board' do

  scenario 'shoot at the opponent board' do
   visit '/start'
   fill_in 'name', with: 'Kirsten'
   click_button('Submit')
   click_button('Place ships')


   visit '/battle'
  #  save_and_open_page
   select 'J', from: 'x_coord'
   select 10, from: 'y_coord'
   click_button('Fire!')
   expect(page).to have_content('Your opponent')
 end

   scenario 'you cannot shoot at the same coordinate more than once' do
      visit '/start'
      fill_in 'name', with: 'Kirsten'
      click_button('Submit')

      click_button('Place ships')

      visit '/battle'
      select 'J', from: 'x_coord'
      select 10, from: 'y_coord'
      click_button('Fire!')

      select 'J', from: 'x_coord'
      select 10, from: 'y_coord'
      click_button('Fire!')

      expect(page).to have_content("Coordinate has been shot already")
   end

end
