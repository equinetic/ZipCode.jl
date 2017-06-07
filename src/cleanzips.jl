const CLEANZIPPATTERN= r"^[0-9]{5}$"

# Mutable
type ZipCodeStr
  val::AbstractString
end

type ZipCodeCleaner
  name::AbstractString
  pattern::Regex
  cleanfun::Function
end

function removewhitespace()::ZipCodeCleaner
  ZipCodeCleaner("Whitespace", r"[ ]*", x -> strip(x))
end

function removezipsuffix()::ZipCodeCleaner
  ZipCodeCleaner("Z+4 Suffix", r"-[0-9]{1,4}", x -> string(split(x,"-")[1]))
end

function padleftzeros()::ZipCodeCleaner
  ZipCodeCleaner("Left Zeros", r"^[0-9]{1,4}$", x -> lpad(x, 5, "0"))
end


function cleanzipcode!(Zip::ZipCodeStr, cleaner::ZipCodeCleaner)::AbstractString
  Zip.val = ismatch(cleaner.pattern, Zip.val) ? cleaner.cleanfun(Zip.val) : Zip.val
end

"""
`CleanZipCode(
    Zip::AbstractString;
    whitespace::Bool=true,      # Remove leading/trailing whitespace
    suffix::Bool=true,          # Remove "Z-{4}" suffix
    padzeros::Bool=true,        # Pad left zeros
    returnNA::Bool=true,        # Return unrecognized values as NA
    enforcestring::Bool=false   # Ensure return type is a String
)`

Description
===========
Returns `Zip` as an AbstractString with the following default corrections:

* Leading and trailing whitespace removed

* Z+4 suffix removed (e.g. 99999-1234 → 99999)

* Padded for left zeros(e.g. 245 → 00245)

If `Zip` does not match the "12345" pattern even after the above
corrections an NA value will be returned.

Usage
=====

  cleanzipcode("01234 ")
  cleanzipcode("1234")
  cleanzipcode("1234-0000")
  cleanzipcode("notaZip")
  cleanzipcode("notaZip", enforcestring=true)

"""
function cleanzipcode(
            Zip::AbstractString;
            whitespace::Bool=true,      # Remove leading/trailing whitespace
            suffix::Bool=true,          # Remove "Z-{4}" suffix
            padzeros::Bool=true,        # Pad left zeros
            returnNA::Bool=true,        # Return unrecognized values as NA
            enforcestring::Bool=false   # Ensure return type is a String
          )::Union{AbstractString, DataArrays.NAtype}
  if ismatch(CLEANZIPPATTERN, Zip)
    return Zip
  else
    # Clean routine
    Zip = ZipCodeStr(Zip)
    if whitespace cleanzipcode!(Zip, removewhitespace()) end
    if suffix cleanzipcode!(Zip, removezipsuffix()) end
    if padzeros cleanzipcode!(Zip, padleftzeros()) end

    # Return routine
    if ismatch(CLEANZIPPATTERN, Zip.val)
      return Zip.val
    else
      return returnNA ? enforceString ? "NA" : NA : Zip.val
    end

  end
end

function cleanzipcode(Zip::Any)
  cleanzipcode(string.(Zip))
end
