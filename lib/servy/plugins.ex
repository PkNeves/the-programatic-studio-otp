defmodule Servy.Plugins do
  require Logger
  alias Servy.Conv

  def emojify(%Conv{status: 200} = conv) do
    %{conv | resp_body: "🎉" <> conv.resp_body <> "🎉"}
  end

  def emojify(%Conv{} = conv), do: conv

  def prettier_path(%Conv{path: path} = conv) do
    case String.split(path, "?") do
      [_] ->
        conv

      [path, id] ->
        case String.split(id, "=") do
          [key, value] ->
            %{conv | path: path <> "/" <> value}
        end
    end
  end

  def prettier_path(%Conv{} = conv), do: conv

  def track(%Conv{status: 404, path: path} = conv) do
    Logger.warn("#{path} is on the loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/whildthing"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect(conv)
end
