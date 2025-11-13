# ref: https://mametter.hatenablog.com/entry/2024/06/24/121002

def post_to_slack(msg)
	resp = Net::HTTP.post_form(
	  URI.parse("https://slack.com/api/chat.postMessage"),
	  {
	    token: ENV['SLACK_TOKEN'],
	    channel: ENV['SLACK_CHANNEL'],
	    text: msg,
	  }
	)

  json = JSON.parse(resp.body, symbolize_names: true)
  json[:ok] #=> true on success, false on failure
end

