require 'CSV'
require 'influxdb'
require 'pry'

desc "drop and rebuild database"
task :event_import => :environment do
  database = 'local_testing'
  username = 'foo'
  password = 'bar'
  name = 'talentradar'

  influxdb = InfluxDB::Client.new
  influxdb.delete_database database

  influxdb.create_database(database)
  influxdb.create_database_user(database, username, password)

  influxdb = InfluxDB::Client.new database, :username => username, :password => password

  i = 1
  CSV.foreach("#{Rails.root.join('lib', 'sendouts_events.csv')}") do |row|
    next if row[0] == 'id'
    
    data = {
      id: row[0],
      email_address: row[1],
      event: row[2],
      timestamp: row[3],
      sendout_token: row[4],
      url: row[5],
      time: Time.parse(row[6]).to_i
    }

    puts "Imported row number #{i}"
    i += 1
    influxdb.write_point(name, data)
  end

end

desc "create events"
task :event_create => :environment do
  CSV.foreach("#{Rails.root.join('lib', 'sendouts_events.csv')}") do |row|
    next if row[0] == 'id'    
    event = Event.create(
      email_address: row[1],
      action: row[2],
      timestamp: row[3],
      sendout_token: row[4],
      url: row[5],
      time: Time.parse(row[6])
      )
    puts "Created event number #{event.id}"
  end

end