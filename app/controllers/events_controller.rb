class EventsController < ApplicationController
  before_filter :load_database_client

  def home
  end

  def sql
  end

  def query_mysql
    @data = Event.select("COUNT(*) AS y, time AS x, action").group("MONTH(time)")

    results = {}

    %W(open click delivered unsubscribe bounce).each do |param|
      results["#{param}"] = @data.where(action: "#{param}").sort_by! {|hsh| hsh[:x]}
    end

    render json: results
  end

  def query_influx
    @data = {}
    %W(open click delivered unsubscribe bounce).each do |param|
      query_data = @influxdb.query "select count(event) from talentradar where event == '#{param}' group by time(1h) limit 0;" 
      next if query_data["talentradar"].nil?
      @data["#{param}"] = []
      query_data["talentradar"].each do |data_point|
        point = {x: data_point['time'], y: data_point['count']}
        @data["#{param}"] << point 
      end

      @data["#{param}"].sort_by! {|hsh| hsh[:x]}
    end
    render json: @data
  end

  private
  def load_database_client
    database = 'local_testing'
    username = 'foo'
    password = 'bar'
    name = 'talentradar'

    @influxdb = InfluxDB::Client.new database, :username => username, :password => password
  end
end
