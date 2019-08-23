-module(servy1).
-export([handle/1]).

handle(Request) ->
  parse(Request).

parse(Request) ->
  route(Request).
route(Request) ->
  format_response(Request).
format_response(_Request) ->
"
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers
".
