require 'json'
require 'sinatra'
require 'income-tax'

set :port, (ENV['PORT'] or 3230)

get '/' do
  'API is running. Try /estimate'
end

get '/estimate' do
  country = params[:country]
  yearly = params[:yearly]

  if country && yearly
    begin
      income_tax = IncomeTax.new(country, yearly)
      result_hash = { 
        :gross_income => income_tax.gross_income,
        :net_income => income_tax.net_income.to_f,
        :taxes => income_tax.taxes.to_f,
        :rate => income_tax.to_f,
        :rate_string => income_tax.rate
      }
      json = JSON.pretty_generate(result_hash)
      content_type :json
      json      
    rescue => e
      status 500
      e.message
    end
  else
    status 400
    'missing parameters'
  end
end

get '/*' do
  status 400
  'nothing on this path'
end

trap("INT") {
  server.shutdown
}

puts "API server started 🚀"
