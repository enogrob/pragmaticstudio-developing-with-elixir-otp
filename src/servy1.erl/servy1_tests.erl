% To run tests:
% erl -make
% erl -noshell -eval "eunit:test(hello_world, [verbose])" -s init stop
%

-module(servy1_tests).
-include_lib("eunit/include/eunit.hrl").

no_name_test() ->
Request = "
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

",
Result = "
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers
",
?assertEqual(Result, servy1:handle(Request)).
