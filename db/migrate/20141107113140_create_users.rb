class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :device_id
      t.datetime :created_at
    end
  end
end
