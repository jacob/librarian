class CreateRecordings < ActiveRecord::Migration
  def self.up
    create_table :recordings do |t|
      t.text :path, :null => false
      t.text :file, :null => false
      t.string :album
      t.string :artist
      t.string :title
      t.string :genre
      t.integer :year
      t.integer :track

      t.timestamps
    end
  end

  def self.down
    drop_table :recordings
  end
end
