@test cleanzipcode("01234") == "01234"
@test cleanzipcode("1234") == "01234"
@test cleanzipcode(" 1234 ") == "01234"
@test cleanzipcode(" 1234-9999") == "01234"
@test isna(cleanzipcode("a"))
@test cleanzipcode("a", returnstring = true) == "NA"
