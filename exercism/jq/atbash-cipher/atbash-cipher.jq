def build_map(keys; values):
  reduce range(10) as $n ({}; . + { ($n | tostring): $n | tostring })
  | reduce range(0; keys | length) as $i
      (.; . + { (keys[$i]): values[$i] })
  
;

"abcdefghijklmnopqrstuvwxyz" as $alphabet
| ($alphabet | split("")) as $plain_lower
| ($alphabet | ascii_upcase | split("")) as $plain_upper
| ($plain_lower | reverse) as $cipher
| build_map($plain_lower + $plain_upper; $cipher + $cipher) as $map
| (.input.phrase 
      | split("")
      | map(select(in($map)) | $map[.])
      | join("")) as $result
| if .property == "decode"
    then $result
    else [ $result | _nwise(5) ] | join(" ") end