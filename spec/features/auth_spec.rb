#encoding: utf-8

require 'spec_helper'

describe 'authentication' do

  it 'displays login page for non-authorized user' do
    %w(/ /charts /logout).each do |url|
      visit url
      current_path.should == '/login'
      page.should have_content('Пожалуйста, авторизуйтесь с помощью учетной записи ВКонтакте')
      page.should have_button 'Войти'
    end
  end

  it 'displays charts page for authenticated user' do
    page.set_rack_session(:current_user => User.create(:vk_id => 123456, :name => 'il.ya'))

    visit '/'
    current_path.should == '/charts'

    page.should have_content 'il.ya'
    #todo implement page.should have_link 'Выйти'

    visit 'login'
    current_path.should == '/charts'
  end

end