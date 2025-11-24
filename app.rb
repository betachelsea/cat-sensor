require "sinatra"
require "csv"
require "dotenv/load"
require "./judge_cat.rb"

CSV_FILE = "#{ENV['PRJ_ROOT']}/latest.csv"


set :bind, "127.0.0.1"
set :port, 4567
set :host_authorization, permitted_hosts: [".ngrok-free.dev"]

get "/" do
  erb :index
end

SUAMA = 'suama'
SARA = 'sara'

get "/data.json" do
  content_type :json
  data = CSV.read(CSV_FILE, headers: true)

  start_date = Date.parse(data[0]["timestamp"])
  finish_date = Date.parse(data[-1]["timestamp"])
  datelist = {}

  (start_date..finish_date).each do |date|
    datelist[date.to_s] = {} # init
  end
  data.map do |d|
    key = Date.parse(d["timestamp"]).to_s
    catname = judge_cat(d["id"])
    datelist[key][catname] ||= 0
    datelist[key][catname] += 1
  end

  sample = {
    labels: datelist.keys,
    datasets: [{
      label: 'suama',
      data: datelist.map{|k,v| v["suama"] || 0 }
    },{
      label: 'sara',
      data: datelist.map{|k,v| v["sara"] || 0 }
    },{
      label: 'unknown',
      data: datelist.map{|k,v| v["unknown"] || 0 }
    }]
  }
  sample.to_json
end

get "/csv" do
  data = CSV.read(CSV_FILE, headers: true)
  data.map {|row| "#{row['timestamp']},#{row['id']}"}.join("<br>")
end
