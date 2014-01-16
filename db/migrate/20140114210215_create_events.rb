class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :email_address
      t.string :action
      t.string :timestamp
      t.string :sendout_token
      t.string :url
      t.datetime :time
      
      t.timestamps
    end
  end
end
