% To run tests:
% erl -make
% erl -noshell -eval "eunit:test(servy1_tests, [verbose])" -s init stop
%

-module(servy1_tests).
-include_lib("eunit/include/eunit.hrl").

wildthings_test() ->
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

bears_test() ->
Request = "
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

",
Result = "
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 5

Bears
",
?assertEqual(Result, servy1:handle(Request)).

bear1_test() ->
Request = "
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

",
Result = "
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 6

Bear 1
",
?assertEqual(Result, servy1:handle(Request)).

wildlife_test() ->
Request = "
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

",
Result = "
HTTP/1.1 404 Not Found
Content-Type: text/html
Content-Length: 18

No /wildlife here!
",
?assertEqual(Result, servy1:handle(Request)).
