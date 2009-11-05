class AddDeletedToRecordings < ActiveRecord::Migration
  def self.up
    add_column :recordings, :deleted, :boolean, :null => false, :default => false
    add_column :recordings, :deleted_at, :datetime
  end

  def self.down
    remove_column :recordings, :deleted
    remove_column :recordings, :deleted_at
  end
end
