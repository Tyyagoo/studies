. as {series: $s, sliceLength: $len}
| ($s | length) as $s_len
| if $s_len == 0 then "series cannot be empty"          | halt_error
  elif $len <  0 then "slice length cannot be negative" | halt_error
  elif $len == 0 then "slice length cannot be zero"     | halt_error
  elif $len > $s_len then "slice length cannot be greater than series length" | halt_error
  else
    [ range(0;$s_len-$len+1) ]
    | map($s[. : . + $len]) end