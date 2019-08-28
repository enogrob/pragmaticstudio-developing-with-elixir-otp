-module(servy1).
% -export([handle/1]).
-compile(export_all).

handle(Request) ->
  format_response(
    track(
      route(
        log(
          rewrite_path(
            parse(Request)
          )
        )
      )
    )
  ).

parse(Request) ->
  Lines = string:split(Request, "\n", all),
  FirstLine = lists:nth(2, Lines),
  [Method, Path, _] = string:split(FirstLine, " ", all),
  #{method => Method, path => Path}.

rewrite_path(Request = #{path := "/wildlife"}) ->
  Request#{status => 301, path => "/wildthings", resp_body => "Bears, Lions, Tigers"};
rewrite_path(Request)  ->
  Request.

log(Request) ->
  erlang:display(Request),
  Request.

route(Request = #{path := "/wildthings"}) ->
  Request#{status => 200, resp_body => "Bears, Lions, Tigers"};
route(Request = #{path := "/bears"}) ->
  Request#{status => 200, resp_body => "Bears"};
route(Request = #{path := "/bears/" ++ Id}) ->
  Request#{status => 200, resp_body => "Bear " ++ Id};
route(Request = #{method := Method, path := Path}) ->
  Request#{status => 404, resp_body => "No " ++ Path ++ " here!"}.

track(Request = #{path := Path, status := 404}) ->
  io:format("Warning: ~p is on the loose~n", [Path]),
  Request;
track(Request) ->
  Request.

format_response(#{status := Status, resp_body := RespBody} = Request) ->
"
HTTP/1.1 " ++ integer_to_list(Status) ++ " " ++ status_reason(Status) ++ "
Content-Type: text/html
Content-Length: " ++ integer_to_list(string:length(RespBody)) ++ "

" ++ RespBody ++ "
".

status_reason(Code) ->
  Map = #{
    200 => "OK",
    201 => "Created",
    301 => "Moved Permanently",
    401 => "Unauthorized",
    403 => "Forbidden",
    404 => "Not Found",
    500 => "Internal Server Error"
  },
  maps:get(Code, Map).
