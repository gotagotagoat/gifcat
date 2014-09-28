require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./dev.db"
)

class Sample < ActiveRecord::Base
end

get '/' do
  ActiveRecord::Base.connection_pool.with_connection do
    @urlData = Sample.limit(9).order("RANDOM()")
    erb :app
  end
end
