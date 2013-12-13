#encoding: utf-8

require 'spec_helper'

describe 'authentication' do

  before :each do
    page.set_rack_session(:nil)
  end

  it 'displays login page for non-authorized user' do
    %w(/ /mybets /charts /logout).each do |url|
      visit url
      current_path.should == '/login'
      page.should have_content('Пожалуйста, авторизуйтесь с помощью учетной записи ВКонтакте')
      page.should have_link 'Войти'
    end
  end

  context 'user logged in' do
    it 'displays bets page for has just logged in user' do
      page.set_rack_session(:current_user => User.create(:vk_id => 123456, :name => 'il.ya'))
      visit '/'
      current_path.should == '/mybets'
    end

    it 'and for user that opens login page' do
      page.set_rack_session(:current_user => User.create(:vk_id => 123456, :name => 'il.ya'))
      visit '/login'
      current_path.should == '/mybets'
    end

    it 'all user\'s pages should have menu and statusbar' do
      page.set_rack_session(:current_user => User.create!(:vk_id => 123456, :name => 'il.ya'))
      %w(/mybets /charts).each do |url|
        visit url
        #menu
        page.should have_link 'Мои ставки'
        page.should have_link 'Чарты'

        #statusbar
        page.should have_link 'Выйти'
      end
    end

  end

end
#todo put login-mechanism in separate method