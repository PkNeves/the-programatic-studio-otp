defmodule Servy.Plugins do
  require Logger

  def emojify(%{status: 200} = conv) do
    %{conv | resp_body: "🎉" <> conv.resp_body <> "🎉"}
  end

  def emojify(conv), do: conv

  def prettier_path(%{path: path} = conv) do
    case String.split(path, "?") do
      [_] -> conv
      [path, id] -> %{conv | path: path <> "/" <> id}
    end
  end

  def prettier_path(conv), do: conv

  def track(%{status: 404, path: path} = conv) do
    Logger.warn("#{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/whildthing"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect(conv)
end
