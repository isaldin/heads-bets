class Artist < ActiveRecord::Base
  attr_accessible :lastfm_url, :mbid, :name, :image

  def self.create_or_update!(artist)
    unless (@result = Artist.find_by_mbid(artist.mbid))
      @result = Artist.create!(
          mbid: artist.mbid,
          name: artist.name,
          lastfm_url: artist.lastfm_url,
          image: artist.image
      )
    end
    @result
  end
end
