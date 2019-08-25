% To run tests:
% erl -make
% erl -noshell -eval "eunit:test(hello_world, [verbose])" -s init stop
%

-module(servy1_tests).
-include_lib("eunit/include/eunit.hrl").

get_wildthings() ->
Request = "
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"
,
Lines = re:spli(Request, "\n"),
[method, path _] = lists:nth(2, Lines),

Result = "
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers
",
get_wildthingstEqual(Result, servy1:handle(Request)).
