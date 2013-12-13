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
    Bet.destroy_all
    Artist.destroy_all
  end

  it 'musts show all user\'s bets' do
    visit '/mybets'
    page.should have_css('.newbet')
    all('div#container div.box.photo').count.should == 0

    @artist = FactoryGirl.build :artist
    @user.do_bet @artist
    visit '/mybets'
    page.should have_css('.newbet')
    all('div#container div.box.photo').count.should == 1
    all('div#container div.box.photo')[0].should have_content('Limp Bizkit')
  end

  it 'musts show adding form when new-link clicked' do
    visit '/mybets'
    find('a.newbet').click
    current_path.should == '/mybets/new'
    page.should have_field 'search_string'
    page.should have_button 'Найти'
  end

  it 'musts show search results when correct artist with mbid looked up' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=chemo&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/chemo_request.json'), :status => 200)

    visit '/mybets'
    find('a.newbet').click
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
    find('a.newbet').click
    fill_in 'search_string', :with => 'enter shikaru'
    click_button 'Найти'
    find('#search_string').value.should == 'enter shikaru'

    page.should have_content(@no_results_message)
  end

  it 'musts show no_results_message when nothing with mbid was found' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=%3Casdf%23%23?&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/nothing_with_mbid_was_found_request.json'), :status => 200)

    visit '/mybets'
    find('a.newbet').click
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
    find('a.newbet').click
    fill_in 'search_string', :with => ''
    click_button 'Найти'
    find('#search_string').value.should == ''

    page.should have_content(@no_results_message)
  end

  it 'musts show so_much_results_message when search results more than 30' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=blood&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/more_than_30_results_request.json'), :status => 200)

    visit '/mybets'
    find('a.newbet').click
    fill_in 'search_string', :with => 'blood'
    click_button 'Найти'
    find('#search_string').value.should == 'blood'

    page.should have_content(@so_much_results_message)
  end

  it 'musts correct do bets' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=blood&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/more_than_30_results_request.json'), :status => 200)

    visit '/mybets'
    find('a.newbet').click
    fill_in 'search_string', :with => 'blood'
    click_button 'Найти'

    @user.bets.count.should == 0
    #all('div#container div.box.photo')
    page.find('div#container div.box.photo', :text => 'Bloodhound Gang').click_link('Сделать ставку')

    current_path.should == '/mybets'
    @user.bets.count.should == 1

    all('div#container div.box.photo').count.should == 1
    all('div#container div.box.photo')[0].should have_content('Bloodhound Gang')
  end

  it 'shouldnt do bet if 10 bets of this user exist' do
    uri = 'http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=blood&api_key=0e7add553b2e3a4e62e655323d407676&format=json'
    stub_request(:get, uri).to_return(:body => File.new('spec/features/json_reqs/more_than_30_results_request.json'), :status => 200)

    10.times do
      artist = FactoryGirl.create :artist, :untitled
      @user.do_bet artist
    end
    visit '/mybets'
    all('div#container div.box.photo').count.should == 10


    find('a.newbet').click
    fill_in 'search_string', :with => 'blood'
    click_button 'Найти'

    #page.should_not have_link('Сделать ставку')
    page.should have_content('Максимальное число ставок - 10 - превышенно.')

    #todo move to controller or user_spec
    @user.bets.count.should == 10
    @user.do_bet(FactoryGirl.create :artist)
    @user.bets.count.should == 10
  end

  it 'should be possible to remove bet' do
    [:lb, :soad, :ratm, :bhg].each do |name|
      @user.do_bet FactoryGirl.create(:artist, name)
    end
    visit '/mybets'

    all('div#container div.box.photo').count.should == 4

    page.find('div#container div.box.photo', :text => 'Bloodhound Gang').find('a.remove_bet').click
    page.should_not have_content('Bloodhound Gang')
    all('div#container div.box.photo').count.should == 3

    page.find('div#container div.box.photo', :text => 'System of a Down').find('a.remove_bet').click
    page.should_not have_content('System of a Down')
    all('div#container div.box.photo').count.should == 2

    @user.bets.count.should == 2
  end


  it 'shouldnt be possible do bet if artist already is head'
  it 'should show user bets page by link [{host}/by/{user_id}]'

end