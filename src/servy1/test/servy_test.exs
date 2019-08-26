defmodule ServyTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  alias Servy.Handler, as: Subject

  doctest Servy

  test "Responds to wildthings" do
    request = """
      GET /wildthings HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """
    result = Subject.handle(request)
    assert result == """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 20

      Bears, Lions, Tigers
      """
  end

  test "Responds to bears" do
    request = """
      GET /bears HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """
    result = Subject.handle(request)
    assert result == """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 5

      Bears
      """
  end

  test "Responds to bears/1" do
    request = """
      GET /bears/1 HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """
    result = Subject.handle(request)
    assert result == """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 6

      Bear 1
      """
  end

  test "Responds to wildlife" do
      request = """
      GET /wildlife HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """
    result = Subject.handle(request)
    assert result == """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 20

      Bears, Lions, Tigers
      """
  end

  test "Responds to wildones" do
    request = """
      GET /wildones HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """
    result = Subject.handle(request)
    assert result == """
      HTTP/1.1 404 Not Found
      Content-Type: text/html
      Content-Length: 18

      No /wildones here!
      """
  end
end
