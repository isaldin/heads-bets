class AuthController < ApplicationController

  skip_before_filter :check_access_rights
  before_filter :check_if_already_authenticated, :except => :logout

  def start_session
    #
  end

  def login
    #
  end

  def logout
    session[:current_user] = nil
    redirect_to '/'
  end

  def fake_session
    session[:current_user] = User.create!(:vk_id => 123456, :name => 'il.ya')
    redirect_to '/'
  end

  def do_it
    parse_token params[:format]

    redirect_to '/'
  end

  def parse_token(token)
    res = []
    token.split('&').each { |el| res << el.split('=') }

    @auth_params = Hash[*res.flatten!]
    @auth_params.symbolize_keys!
  end

  private

  def check_if_already_authenticated
    if current_user?
      redirect_to :controller => :bets
    end
  end

end
