class CreateRepositories < ActiveRecord::Migration
  def self.up
    create_table :repositories do |t|
      t.string :base_ftp
      t.string :base_path

      t.timestamps
    end
    add_column :recordings, :repository_id, :integer
  end

  def self.down
    drop_table :repositories
  end
end
