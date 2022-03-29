defmodule ControlFlow do
  @doc """
  Many built-in functions have two forms. The xxx form returns the tuple
  {:ok, data} and the xxx! form returns data on success but raises an exception
  otherwise. However, some functions don’t have the xxx! form.
  Write an ok! function that takes an arbitrary parameter. If the parameter
  is the tuple {:ok, data}, return the data. Otherwise, raise an exception
  containing information from the parameter.
  
  ## Examples:
  
      iex> try do
      ...>  ControlFlow.ok!(File.open("non_existing_file.404"))
      ...> catch
      ...>  {:error, reason} -> reason
      ...> end
      :enoent
  """
  def ok!({:ok, data}), do: data
  def ok!(error), do: throw(error)
end
