.moment
| if test("T") then . + "Z" else . + "T00:00:00Z" end
| fromdateiso8601 + 1000000000
| todateiso8601
| .[0:-1]