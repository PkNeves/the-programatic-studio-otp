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

  def my_map(list, function, acc \\ [])

  def my_map([head | tail], function, acc) do
    return = function.(head)
    my_map(tail, function, acc ++ [return])
  end

  def my_map([], _, acc) do
    acc
  end

  def my_map2([head | tail], fun) do
    [fun.(head) | my_map(tail, fun)]
  end

  def my_map2([], _fun), do: []
end
