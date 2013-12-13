class ChartsController < ApplicationController

  skip_before_filter :check_access_rights, :except => :index

  def index
    @artists = Artist.all.uniq.sort{ |a, b| b.bets.count <=> a.bets.count }
  end

end
