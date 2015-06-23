require 'spec_helper'

feature 'placing ships' do

  scenario 'it has a form to place ships' do
    visit '/start?name=massi'
    click_button('Place ships')
    expect(page).to have_content 'Place your ships, Admiral Massi'
  end

end
