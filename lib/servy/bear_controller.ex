defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  @template_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings \\ []) do
    content = @template_path |> Path.join(template) |> EEx.eval_file(bindings)
    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear name #{name}"}
  end

  def delete(conv) do
    %{conv | status: 403, resp_body: "Deleting a bear is forbidden"}
  end
end
