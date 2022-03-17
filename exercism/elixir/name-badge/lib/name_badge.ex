defmodule NameBadge do
  def print(id, name, department) do
    ""
    |> (&(&1 <> if(id, do: "[#{id}] - ", else: ""))).()
    |> (&(&1 <> "#{name} - ")).()
    |> (&(&1 <> if(department, do: String.upcase(department), else: "OWNER"))).()
  end
end
