class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :device_id
      t.datetime :created_at
    end
  end
end
