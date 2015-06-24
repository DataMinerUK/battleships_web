require 'launchy'

feature 'shotting at board' do

  skip 'shoot at the opponent board' do
   visit '/start'
   fill_in 'name', with: 'Kirsten'
   click_button('Submit')
   click_button('Place ships')

   visit '/battle'
   select 'J', from: 'x_coord'
   select 10, from: 'y_coord'
   click_button('Fire!')
   # save_and_open_page
   expect(page).to have_content('Your opponent')
 end

   skip 'you cannot shoot at the same coordinate more than once' do
      visit '/start'
      fill_in 'name', with: 'Kirsten'
      click_button('Submit')

      click_button('Place ships')

      visit '/battle'
      # select 'J', from: 'x_coord'
      # select 10, from: 'y_coord'
      click_button('Fire!')

      # select 'J', from: 'x_coord'
      # select 10, from: 'y_coord'
      click_button('Fire!')

      expect(page).to have_content("You already shot there")
   end

end
