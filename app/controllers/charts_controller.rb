class ChartsController < ApplicationController

  def index
    @bets = Bet.all
  end

end
