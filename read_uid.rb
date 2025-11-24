require "net/http"
require "json"
require "nfc"
require "./slack"
require "./csv"
require "./judge_cat"

context = NFC::Context.new
device = context.open nil

found_id = nil
cats = CSV.read('./cats.csv', headers: true)

def fetch_ngrok_url
  script = "#{ENV['PRJ_ROOT']}/ngrok-url.sh"
  url = `#{script}`.strip
  raise "ngrok-url.sh failed" if url.empty? || url.start_with?("ERROR")
  url
end

loop do
  ans = device.select
  if !found_id.nil? && ans == false
    found_id = nil
  elsif found_id.nil? && ans != false
    found_id = ans.to_s
    cat_name = judge_cat(found_id)
    msg = "#{found_id}:#{cat_name}\n#{fetch_ngrok_url}"
    post_to_slack(msg)
    append_with_limit([Time.now, found_id])
    puts "post_to_slack: #{found_id}"
  else
    # skip
  end
end

