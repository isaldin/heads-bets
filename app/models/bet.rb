class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :artist

  attr_accessible :artist, :user, :artist_id, :user_id
end
