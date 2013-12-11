class User < ActiveRecord::Base
  has_many :bets

  attr_accessible :name,
                  :vk_id,
                  :id

  def do_bet(artist)
    @artist = Artist.create_or_update!(artist)
    Bet.create!(:user_id => id, :artist => @artist) unless
        Bet.where("user_id = #{id} and artist_id = #{@artist.id}").first
  end
end
