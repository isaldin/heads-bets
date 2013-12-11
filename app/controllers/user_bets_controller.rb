class UserBetsController < ApplicationController

  def new
    @artist = Artist.new(params[:artist])

    current_user.do_bet(@artist)

    redirect_to controller: :bets
  end

end
