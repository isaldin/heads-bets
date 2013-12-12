class User < ActiveRecord::Base
  has_many :bets

  attr_accessible :name,
                  :vk_id,
                  :id,
                  :is_admin

  def do_bet(artist)
    return if bets.count == 10

    @artist = Artist.create_or_update!(artist)
    Bet.create!(:user_id => id, :artist => @artist) unless
        Bet.where("user_id = #{id} and artist_id = #{@artist.id}").first
  end
end
