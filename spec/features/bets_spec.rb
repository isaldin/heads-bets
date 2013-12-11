#encoding: utf-8

require 'spec_helper'

describe 'bets' do

  before :each do
    @user = FactoryGirl.create :user
    page.set_rack_session(:current_user => @user)
    @no_results_message = 'По вашему запросу ничего не найдено :('
    @so_much_results_message = 'Найдено более 30 исполнителей.'
  end
  after :each do
    page.set_rack_session(:current_user => nil)
    User.destroy_all
  end

  it 'musts show all user\'s bets' do
    visit '/mybets'
    within_table 'bets' do
      all('tr').count.should == 0
    end

    @artist = FactoryGirl.build :artist
    @user.do_bet @artist
    visit '/mybets'
    within_table 'bets' do
      all('tr').count.should == 1
      all('tr')[0].should have_content('Limp Bizkit')
    end

    page.should have_link 'new'
  end

  it 'musts show adding form when new-link clicked' do
    visit '/mybets'
    click_link 'new'
    current_path.should == '/mybets/new'
    page.should have_field 'search_string'
    page.should have_button 'Найти'
  end

  it 'musts show search results when correct artist with mbid looked up' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=chemo&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/chemo_request.json'), :status => 200)

    visit '/mybets'
    click_link 'new'
    fill_in 'search_string', :with => 'chemo'
    click_button 'Найти'
    find('#search_string').value.should == 'chemo'

    page.should have_content('The Chemodan')

    page.should_not have_content(@no_results_message)
    page.should_not have_content('The Chemodan Ft. Brick Bazuka')
    page.should_not have_content('The Chemodan Ft. Sony Money')
  end

  it 'musts show no_results_message when nothing was found' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=enter%20shikaru&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/entershikaru_request.json'), :status => 200)

    visit '/mybets'
    click_link 'new'
    fill_in 'search_string', :with => 'enter shikaru'
    click_button 'Найти'
    find('#search_string').value.should == 'enter shikaru'

    page.should have_content(@no_results_message)
  end

  it 'musts show no_results_message when nothing with mbid was found' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=%3Casdf%23%23?&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/nothing_with_mbid_was_found_request.json'), :status => 200)

    visit '/mybets'
    click_link 'new'
    fill_in 'search_string', :with => '<asdf##?'
    click_button 'Найти'
    find('#search_string').value.should == '<asdf##?'

    page.should have_content(@no_results_message)
  end

  #todo показывать suitable error msg
  it 'musts show no_results_message when search request is invalid' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/error_request.json'), :status => 200)

    visit '/mybets'
    click_link 'new'
    fill_in 'search_string', :with => ''
    click_button 'Найти'
    find('#search_string').value.should == ''

    page.should have_content(@no_results_message)
  end

  it 'musts show so_much_results_message when search results more than 30' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=blood&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/more_than_30_results_request.json'), :status => 200)

    visit '/mybets'
    click_link 'new'
    fill_in 'search_string', :with => 'blood'
    click_button 'Найти'
    find('#search_string').value.should == 'blood'

    page.should have_content(@so_much_results_message)
  end

  it 'musts correct do bets' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=blood&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/more_than_30_results_request.json'), :status => 200)

    visit '/mybets'
    click_link 'new'
    fill_in 'search_string', :with => 'blood'
    click_button 'Найти'

    @user.bets.count.should == 0
    page.find('li', :text => 'Bloodhound Gang').click_link('Сделать ставку')
    current_path.should == '/mybets'
    @user.bets.count.should == 1

    within_table 'bets' do
      all('tr').count.should == 1
      all('tr')[0].should have_content('Bloodhound Gang')
    end
  end

end