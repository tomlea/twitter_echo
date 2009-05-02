class CreateEchoes < ActiveRecord::Migration
  def self.up
    create_table :echoes do |t|
      t.string :username, :null => :false
      t.string :relayed_ids
      t.string :auth_details, :null => :false
      t.timestamps
    end
  end

  def self.down
    drop_table :echoes
  end
end
