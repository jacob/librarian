class CreateRecordings < ActiveRecord::Migration
  def self.up
    create_table :recordings do |t|

      t.text :path, :null => false
      t.text :file, :null => false

      t.text :raw_tag_info

      t.string :album
      t.string :artist
      t.string :title
      t.string :genre
      t.string :label
      t.integer :year

      #2nd order data
      t.string :url
      t.integer :track
      t.text :tracklist

      t.timestamps
    end
  end

  def self.down
    drop_table :recordings
  end
end
