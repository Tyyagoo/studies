if (test("^[\\d\\s]+$") | not) then false
else
  gsub("\\s"; "")
  | explode
  | if length <= 1 then false
  else
    map(. - 48) as $numbers
    | (length % 2 == 0) as $even
    | reduce range(0; length) as $i (0;
        . + if (($even and $i % 2 == 0) or (($even | not) and $i % 2 != 0)) then
          $numbers[$i] * 2 | if . > 9 then . - 9 else . end
        else
          $numbers[$i]
        end)
    | (. % 10 == 0) end end