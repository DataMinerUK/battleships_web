require 'spec_helper'

feature 'ending game' do

  skip 'if there is a winner the game announces it' do
    # Not sure how to ensure a board has all ships sunk in a feature test
    expect(page).to have_content "GAME OVER!"

  end

end
