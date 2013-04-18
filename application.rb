require 'sinatra'
require 'json'
require './models/statements_saver'


get '/send_statements' do

  StatementsSaver.save(params)
  content_type :json
  { :result => 1}.to_json

end