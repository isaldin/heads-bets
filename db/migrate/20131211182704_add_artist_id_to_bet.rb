class AddArtistIdToBet < ActiveRecord::Migration
  def change
    add_column :bets, :artist_id, :integer
  end
end
