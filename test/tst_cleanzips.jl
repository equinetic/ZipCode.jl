@test CleanZipCode("01234") == "01234"
@test CleanZipCode("1234") == "01234"
@test CleanZipCode(" 1234 ") == "01234"
@test CleanZipCode(" 1234-9999") == "01234"
@test isna(CleanZipCode("a"))
@test CleanZipCode("a", returnstring = true) == "NA"
