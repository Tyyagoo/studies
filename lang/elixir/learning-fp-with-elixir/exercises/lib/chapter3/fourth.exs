import Exercises.Chapter3.Third, only: [tax: 1]

calculate_tax = fn salary ->
  {salary, tax(salary)}
end

format_data = fn {salary, tax} ->
  "Gross Salary: $#{salary}\nNet Wage: $#{salary - tax}\nTax: $#{tax}"
end

IO.gets("Insert your salary: ")
|> Integer.parse()
|> case do
  :error -> IO.puts("Salary must be a number.")
  {salary, _} -> salary |> calculate_tax.() |> format_data.() |> IO.puts()
end
