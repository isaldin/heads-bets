class UserBetsController < ApplicationController

  def new
    @artist = Artist.new(params[:artist])

    current_user.do_bet(@artist)

    redirect_to controller: :bets
  end

  def destroy
    Bet.find(params[:id]).destroy

    redirect_to :controller => :bets, :action => :index
  end

end
