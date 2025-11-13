require "sinatra"
require "csv"

CSV_FILE = "#{ENV['PRJ_ROOT']}/latest.csv"


set :bind, "0.0.0.0"   # LANからも見せたいならこのまま。ngrok経由のみにするなら "127.0.0.1"
set :port, 4567
set :protection, except: :host_header  # ← 手っ取り早い解決

=begin
configure do
  set :bind, "0.0.0.0"  # LANからアクセス可
  set :host_authorization, {
    permitted_hosts: [
      ENV['PRJ_LOCAL_DOMAIN'],
      "#{ENV['PRJ_LOCAL_DOMAIN']}:4567",
      "#{ENV['NGROK_URI']}:4567",
    ]
  }
end

=end

get "/" do
  data = CSV.read(CSV_FILE, headers: true)
  data.map {|row| "#{row['timestamp']},#{row['id']}"}.join("<br>")
end
