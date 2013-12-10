#encoding: utf-8

require 'spec_helper'

describe 'bets' do

  before :each do
    @user = User.create!(:vk_id => 123456, :name => 'il.ya')
    page.set_rack_session(:current_user => @user)
  end
  after :each do
    page.set_rack_session(:current_user => nil)
  end

  it 'musts show all user bets' do
    #todo load bets
    visit '/mybets'
    page.should have_table 'bets'
    page.should have_link 'new'
  end

  it 'musts show adding form when new-link clicked' do
    visit '/mybets'
    click_link 'new'
    current_path.should == '/mybets/new'
    page.should have_field 'search_string'
    page.should have_button 'Найти'
  end

end