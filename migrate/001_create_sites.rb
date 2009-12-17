class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :url, :default => 'http://.tumblr.com/'
      t.string :email
      t.string :password
      t.string :name
      t.string :title
      t.text :description
      t.datetime :fetched_at
    end
  end

  def self.down
    drop_table :sites
  end
end