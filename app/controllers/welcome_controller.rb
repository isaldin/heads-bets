class WelcomeController < ApplicationController

  def index
    if current_user?
      redirect_to :controller => :bets
    else
      redirect_to :controller => :auth, :action => :login
    end
  end

end
