defmodule Servy.Recurse do
  def sum(list, value \\ 0)

  def sum([head | tail], value) do
    value = value + head
    sum(tail, value)
  end

  def sum([], value), do: value

  def triple(list, return \\ [])

  def triple([head | tail], return) do
    return = return ++ [head * 3]
    triple(tail, return)
  end

  def triple([], return), do: return
end
