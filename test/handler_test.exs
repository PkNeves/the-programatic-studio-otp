defmodule Servy.HandlerTest do
  use ExUnit.Case
  alias Servy.Handler

  describe "handle/1" do
    test "should run a GET wildthings" do
      request = """
      GET /wildthings HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 200 OK
             Content-Type: text/html
             Content-Length: 28

             🎉Bears, Lions, Tigers🎉
             """ = Servy.Handler.handle(request)
    end

    test "should run a GET bears" do
      request = """
      GET /bears HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 200 OK
             Content-Type: text/html
             Content-Length: 44

             🎉<ul><li>Scarface - Grizzly</li></ul>🎉
             """ = Servy.Handler.handle(request)
    end

    test "should not found route GET bigfoot" do
      request = """
      GET /bigfoot HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 404 Not Found
             Content-Type: text/html
             Content-Length: 17

             No /bigfoot here!
             """ = Servy.Handler.handle(request)
    end

    test "should found a GET bears 1" do
      request = """
      GET /bears/1 HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 200 OK
             Content-Type: text/html
             Content-Length: 30

             🎉<h1>Bear 1: Teddy</h1>🎉
             """ = Servy.Handler.handle(request)
    end

    test "should forbidden delete any bear" do
      request = """
      DELETE /bears/1 HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 403 Forbidden
             Content-Type: text/html
             Content-Length: 28

             Deleting a bear is forbidden
             """ = Servy.Handler.handle(request)
    end

    test "should not found whildthing" do
      request = """
      GET /wildlife HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 404 Not Found
             Content-Type: text/html
             Content-Length: 20

             No /whildthing here!
             """ = Servy.Handler.handle(request)
    end

    test "should get a bear with query params" do
      request = """
      GET /bears?id=1 HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 200 OK
             Content-Type: text/html
             Content-Length: 30

             🎉<h1>Bear 1: Teddy</h1>🎉
             """ = Servy.Handler.handle(request)
    end

    test "should get a page about" do
      request = """
      GET /about HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 200 OK
             Content-Type: text/html
             Content-Length: 328

             🎉<h1>Clark's Wildthings Refuge</h1>

             <blockquote>
               When we contemplate the whole globe as one great dewdrop, stripe and dotted with continents and islands, flying through space with other stars all signing and shining together as one, the whole universe appears as an infinite storm of beauty. -- John Muir
             </blockquote>🎉
             """ = Servy.Handler.handle(request)
    end

    test "Deve devolver um form para o get de um novo bear" do
      request = """
      GET /bears/new HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 200 OK
             Content-Type: text/html
             Content-Length: 239

             🎉<form action=\"/bears\" method=\"POST\">
               <p>
                 Name:<br/>
                 <input type=\"text\" name=\"name\">
               </p>
               <p>
                 Type:<br/>
                 <input type=\"text\" name=\"type\">
               </p>
               <p>
                 <input type=\"submit\" value=\"Create Bear\">
               </p>
             </form>🎉
             """ = Servy.Handler.handle(request)
    end

    test "should return a contact page" do
      request = """
      GET /pages/contact HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert """
             HTTP/1.1 200 OK
             Content-Type: text/html
             Content-Length: 26

             🎉<h1> Contact </h1>🎉
             """ = Servy.Handler.handle(request)
    end

    test "should create a new bear with POST" do
      request = """
      POST /bears HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Content-Type: application/x-www-form-urlencoded
      Accept: */*

      name=Boloo&type=Brown
      """

      assert """
             HTTP/1.1 201 Created
             Content-Type: text/html
             Content-Length: 31

             Created a Brown bear name Boloo
             """ = Servy.Handler.handle(request)
    end

    test "The order of the headers should not matter" do
      request = """
      POST /bears HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*
      Content-Type: application/x-www-form-urlencoded
      Content-Length: 21

      name=Boloo&type=Brown
      """

      assert """
             HTTP/1.1 201 Created
             Content-Type: text/html
             Content-Length: 31

             Created a Brown bear name Boloo
             """ = Servy.Handler.handle(request)
    end
  end
end
