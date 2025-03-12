defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests
  """
  @pages_path Path.expand("pages", File.cwd!())

  import Servy.Plugins, only: [rewrite_path: 1, prettier_path: 1, log: 1, track: 1, emojify: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.HandleFile, only: [handle_file: 2]
  alias Servy.Conv
  alias Servy.BearController

  @doc "Transform the request into a response"
  def handle(request) do
    request
    |> parse()
    |> prettier_path()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> emojify()
    |> format_response()
  end

  def route(%Conv{method: "GET", path: "/pages/" <> page} = conv) do
    @pages_path
    |> Path.join(page <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv),
    do: %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}

  def route(%Conv{method: "GET", path: "/bears"} = conv),
    do: BearController.index(conv)

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv),
    do: BearController.delete(conv)

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    "../../pages"
    |> Path.expand(__DIR__)
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv),
    do: %{conv | status: 404, resp_body: "No #{path} here!"}

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

defmodule Servy.Run do
  def run() do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /bigfoot HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /bears/1 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    DELETE /bears/1 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /wildlife HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /bears?id=1 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /about HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /bears/new HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /pages/contact HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    POST /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Content-Type: application/x-www-form-urlencoded
    Accept: */*

    name=Boloo&type=Brown
    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    POST /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 21

    name=Boloo&type=Brown
    """

    response = Servy.Handler.handle(request)
    IO.puts(response)

    request = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = Servy.Handler.handle(request)
    IO.puts(response)
  end
end
