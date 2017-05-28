# Mutable
type ZipCodeStr
  val::String
end

type ZipCodeCleaner
  name::String
  pattern::Regex
  cleanfun::Function
end

const CLEAN= r"^[0-9]{5}$"
const CLEANERS = [
  ZipCodeCleaner("Whitespace", r"[ ]*", x -> strip(x)),
  ZipCodeCleaner("Z+4 Suffix", r"-[0-9]{1,4}", x -> string(split(x,"-")[1])),
  ZipCodeCleaner("Left Zeros", r"^[0-9]{1,4}$", x -> lpad(x, 5, "0"))
]

function CleanZipCode!(cleaner::ZipCodeCleaner, Zip::ZipCodeStr)
  Zip.val = ismatch(cleaner.pattern, Zip.val) ? cleaner.cleanfun(Zip.val) : Zip.val
end

"""
`CleanZipCode(Zip; returnstring = false)`

Description
===========
Returns `Zip` as a string with the following corrections:

* Leading and trailing whitespace removed

* Z+4 suffix removed (e.g. 99999-1234 → 99999)

* Padded for left zeros(e.g. 245 → 00245)

If `Zip` does not match the "12345" pattern even after the above
corrections an NA value will be returned.

Usage
=====

  CleanZipCode("01234 ")
  CleanZipCode("1234")
  CleanZipCode("1234-0000")
  CleanZipCode("notaZip")
  CleanZipCode("notaZip", returnstring = true)

"""
function CleanZipCode(Zip::String; returnstring = false)
  if ismatch(CLEAN, Zip)
    return Zip
  else
    Zip = ZipCodeStr(Zip)
    for c in CLEANERS
      CleanZipCode!(c, Zip)
    end
    return ismatch(CLEAN, Zip.val) ? Zip.val : returnstring ? "NA" : NA
  end
end

function CleanZipCode(Zip::Any)
  CleanZipCode(string.(Zip))
end
