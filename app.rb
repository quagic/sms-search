require "google/api_client"
require "sinatra"
require "twilio-ruby"
require "json"

post "/receivesms" do
  client = Google::APIClient.new(:key => "AIzaSyAKXQIM2o3v8IdtJn4poj-6I31cJZ1976k")
  client.authorization = nil
  search = client.discovered_api('customsearch')

  response = client.execute(
    :api_method => search.cse.list,
    :parameters => {
      'q' => params[:Body],
      'cx' => "001110360981758596981%3Arayp5ppxfbo",
      'num' => '3'
    }
  )
  body = JSON.parse(response.body)
  items = body['items']

  twiml = Twilio::TwiML::Response.new do |r|
    if items.nil? or items.empty?
      r.Sms "No results found!"
    else
      items.each do |item|
        r.Sms "#{item['title']}: #{item['link']}"
      end
    end
  end
  twiml.text
end
