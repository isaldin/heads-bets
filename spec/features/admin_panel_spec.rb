#encoding: utf-8

require 'spec_helper'

describe 'Admin Panel' do

  before :each do
    page.set_rack_session(:current_user => nil)
  end

  it 'should restrict access and redirect to bets-page when non-admin request admin panel' do
    page.set_rack_session(:current_user => FactoryGirl.create(:user).id)
    visit '/admin'
    current_path.should == '/mybets'
    page.should have_content('Вы не авторизованы')
  end

  it 'should show admin panel when admin request admin panel' do
    page.set_rack_session(:current_user => FactoryGirl.create(:user, :admin).id)
    visit '/admin'
    page.should have_content('Add head')
  end

  #it 'should be possible mark artist as head' do
  #  page.set_rack_session(:current_user => FactoryGirl.create(:user, :admin).id)
  #  visit '/admin'
  #
  #  fill_in 'head_mbid', :with => 'some_mbid'
  #  click_button 'add'
  #
  #  Artist.find_by_mbid('some_mbid').count.should == 1
  #  Artist.find_by_mbid('some_mbid').first.is_head.should == true
  #end

end