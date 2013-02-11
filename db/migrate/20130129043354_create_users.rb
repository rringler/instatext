class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
    	t.string  :access_token
      t.string  :username
    	t.string  :phone
      t.integer :max_alerts, default: 0
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :phone, unique: true
  end

  def self.down
  	drop_table :users
  end
end
