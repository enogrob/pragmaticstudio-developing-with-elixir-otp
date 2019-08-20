defmodule ServyTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  alias Servy.Handler, as: Subject

  doctest Servy

  test "Responds to handle properly" do
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

  test "Responds to parse properly" do
    request = """
      GET /wildthings HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """
    result = Subject.parse(request)
    assert result == %{ method: "GET", path: "/wildthings", resp_body: "", status: nil}

    request = """
      GET /bears HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """
    result = Subject.parse(request)
    assert result == %{ method: "GET", path: "/bears", resp_body: "", status: nil}

    request = """
      GET /bears/1 HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """
    result = Subject.parse(request)
    assert result == %{ method: "GET", path: "/bears/1", resp_body: "", status: nil}
  end

  test "Responds to log properly" do
    conv = %{ method: "GET", path: "/wildthings", resp_body: "" }
    result = Subject.log(conv)
    assert result == %{method: "GET", path: "/wildthings", resp_body: ""}

    conv = %{ method: "GET", path: "/bears", resp_body: "" }
    result = Subject.log(conv)
    assert result == %{method: "GET", path: "/bears", resp_body: ""}

    conv = %{ method: "GET", path: "/bears/1", resp_body: "" }
    result = Subject.log(conv)
    assert result == %{method: "GET", path: "/bears/1", resp_body: ""}
  end

  test "Responds to route properly" do
    conv = %{ method: "GET", path: "/wildthings", resp_body: "", status: nil}
    result = Subject.route(conv)
    assert result == %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers", status: 200 }

    conv = %{ method: "GET", path: "/bears", resp_body: "", status: nil}
    result = Subject.route(conv)
    assert result == %{ method: "GET", path: "/bears", resp_body: "Bears", status: 200 }

    conv = %{ method: "GET", path: "/bears/1", resp_body: "Bear 1", status: nil}
    result = Subject.route(conv)
    assert result == %{ method: "GET", path: "/bears/1", resp_body: "Bear 1", status: 200 }
  end

  test "Responds to format_response properly" do
    conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers", status: 200}
    assert IO.puts Subject.format_response(conv) == """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 20
      Bears, Lions, Tigers
      """

    conv = %{ method: "GET", path: "/bears", resp_body: "Bears", status: 200}
    assert IO.puts Subject.format_response(conv) == """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 5
      Bears
      """

    conv = %{ method: "GET", path: "/bears/1", resp_body: "Bear 1", status: 200}
    assert IO.puts Subject.format_response(conv) == """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 7
      Bears 1
      """
  end
end
