@test cleanzipcode("01234") == "01234"
@test cleanzipcode("1234") == "01234"
@test cleanzipcode(" 1234 ") == "01234"
@test cleanzipcode(" 1234-9999") == "01234"
@test isna(cleanzipcode("a"))
@test cleanzipcode("a", enforcestring = true) == "NA"

@test cleanzipcode(1234) == "01234"
@test cleanzipcode(0123456789, returnNA=false) == "123456789"

zipvec1 = ["1234", 1234, "1234-1234"]
@test cleanzipcode(zipvec1, enforcestring=true) == ["01234", "01234", "01234"]

cleaner1 = removewhitespace()
cleaner2 = removezipsuffix()
cleaner3 = padleftzeros()

@test ismatch(cleaner1.pattern, " 01234 ")
@test cleaner1.cleanfun(" 01234 ") == "01234"
@test ismatch(cleaner2.pattern, "01234-9999")
@test cleaner2.cleanfun("01234-9999") == "01234"
@test ismatch(cleaner3.pattern, "1234")
@test cleaner3.cleanfun("1234") == "01234"
