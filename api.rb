require 'webrick'
require 'income-tax'

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)      
    result = nil
    status = 200

    case request.path
      when "/effective-rate"
        country = request.query["country"]
        yearly = request.query["yearly"]
        if country && yearly
          begin
            result = IncomeTax.new(country, yearly).to_f
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
      else
        status = 404
        result = "no such path"
    end 

    response.status = status
    response.body = result.to_s + "\n"
  end
end

server = WEBrick::HTTPServer.new(:Port => 80)

server.mount "/", MyServlet

trap("INT") {
  server.shutdown
}

server.start
