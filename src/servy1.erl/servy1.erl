-module(servy1).
-export([handle/1, parse/1]).

handle(Request) ->
  parse(Request).

parse(Request) ->
  Lines = re:split(Request, "\n"),
  FirstLine = lists:nth(2, Lines),
  [Mehod, Path, _] = re:split(FirstLine, " "),
  #{method => Method, path => Path}.

route(Request) ->
  format_response(Request).
format_response(_Request) ->
"
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers
".
