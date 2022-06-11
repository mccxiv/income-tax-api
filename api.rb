require 'json'
require 'webrick'
require 'income-tax'

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)      
    result = nil
    status = 200

    case request.path
      when "/estimate"
        country = request.query["country"]
        yearly = request.query["yearly"]
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
            puts result_hash
            result = JSON.pretty_generate(result_hash)
          rescue => e
            status = 500
            result = e.message
          end
        else
          status = 400
          result = "missing parameters"
        end
      when "/healthcheck"
        result = "ok"
      when '/'
        result = "API is running. Try /estimate"
      else
        status = 404
        result = "no such path"
    end 

    response.status = status
    response.body = result.to_s + "\n"
  end
end

server = WEBrick::HTTPServer.new(:Port => (ENV['PORT'] or 3230))

server.mount "/", MyServlet

trap("INT") {
  server.shutdown
}

puts "Starting API server 🚀"

server.start
