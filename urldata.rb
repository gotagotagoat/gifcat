require 'tumblr_client'
require 'active_record'

# start command => `be foreman run ruby urldata.rb`

I18n.config.enforce_available_locales = false

Tumblr.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.oauth_token = ENV['OAUTH_TOKEN']
  config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
end

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3:dev.db')

class Sample < ActiveRecord::Base
  validates :url, uniqueness: true
  validates :linkurl, uniqueness: true
end

Sample.delete_all

client = Tumblr::Client.new
responseGif = client.tagged('gif')
@cnt = 0
endOfLoop = false

loop do

  responseGif.each do |data|
    type = data["type"]
    tags = data["tags"]
    @cnt += 1
    if type == "photo" && /"cat"|"kitten"/i =~ tags.to_s
      Sample.create(:url => "#{data["photos"][0]["original_size"]["url"]}", :linkurl => "#{data["short_url"]}")
    end
    if @cnt % 20 == 0
      timestamp = data["featured_timestamp"]
      responseGif = client.tagged('gif', :before=>"#{timestamp}")
    end

    if responseGif.empty? == true || responseGif.length != 20
      endOfLoop = true
    end

  end

  break if endOfLoop && @cnt % 20 != 0

end
