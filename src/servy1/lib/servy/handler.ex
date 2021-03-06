defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method,
       path: path,
       resp_body: "",
       status: nil
     }
  end

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings"}
  end
  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end
  def route(%{ method: "GET", path: "/bears"} = conv) do
    %{ conv | status: 200, resp_body: "Bears" }
  end
  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end
  def route(%{ path: path } = conv), do: %{ conv | status: 404, resp_body: "No #{path} here!"}

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose"
    conv
  end
  def track(conv), do: conv

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      301 => "Moved Permanently",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end
