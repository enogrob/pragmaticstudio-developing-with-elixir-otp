defmodule Servy.Handler do
  def handle(request) do
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

expect_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-length: 20

Bears, Lions, Tigers
"""

response = Servy.handler.handle(request)

IO.puts response
