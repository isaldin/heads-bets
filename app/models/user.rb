class User < ActiveRecord::Base
  attr_accessible :name, :vk_id, :bets

  def do_bet(artist)
    Bet.create!(:user_id => self.id, :artist_id => artist[:mbid])
  end

  has_many :bets
end
