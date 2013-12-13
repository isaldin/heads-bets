class ChartsController < ApplicationController

  def index
    @artists = Artist.all.uniq.sort{ |a, b| b.bets.count <=> a.bets.count }
  end

end
