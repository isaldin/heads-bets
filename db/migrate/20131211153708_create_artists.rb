class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :lastfm_url
      t.string :mbid

      t.timestamps
    end
  end
end
