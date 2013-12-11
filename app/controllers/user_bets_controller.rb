class UserBetsController < ApplicationController

  def new
    @artist = params[:artist]

    current_user.do_bet(@artist)

    redirect_to controller: :bets
  end

end
