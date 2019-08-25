-module(servy1).
% -export([handle/1, parse/1]).
-compile(export_all).

  handle(Request) ->
    format_response(
      route(
        parse(Request)
      )
    ).

parse(Request) ->
  Lines = string:split(Request, "\n", all),
  FirstLine = lists:nth(2, Lines),
  [Method, Path, _] = string:split(FirstLine, " ", all),
  #{method => Method, path => Path}.

route(Request = #{path := "/wildthings"}) ->
  Request#{resp_body => "Bears, Lions, Tigers"};
route(Request = #{path := "/bears"}) ->
  Request#{resp_body => "Bears"};
route(Request = #{method := Method, path := Path}) ->
  Request#{resp_body => "No " ++ Path ++ " here!"}.

format_response(#{resp_body := RespBody} = Request) ->
"
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: " ++ integer_to_list(string:length(RespBody)) ++ "

" ++ RespBody ++ "
".
