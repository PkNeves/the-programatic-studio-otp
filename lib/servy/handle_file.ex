defmodule Servy.HandleFile do
  def handle_file({:error, :enoent}, conv),
    do: %{conv | status: 404, resp_body: "File not fount"}

  def handle_file({:error, reason}, conv),
    do: %{conv | status: 500, resp_body: "File error: #{reason}"}

  def handle_file({:ok, content}, conv), do: %{conv | status: 200, resp_body: content}
end
