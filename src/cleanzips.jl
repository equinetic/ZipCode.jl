mutable struct ZipCodeStr
  val::AbstractString
end

"""
```julia
mutable struct ZipCodeCleaner
  name::AbstractString
  pattern::Regex
  cleanfun::Function
end
```

Holds a textual identifier for clarity purposes, a regex
pattern to match a potential ZIP code to, and a function to
apply when a match is found.
"""
struct ZipCodeCleaner
  name::AbstractString
  pattern::Regex
  cleanfun::Function
end

"Returns a ZipCodeCleaner for stripping whitespace"
function removewhitespace()::ZipCodeCleaner
  ZipCodeCleaner("Whitespace", r"[ ]*", x -> strip(x))
end

"Returns a ZipCodeCleaner for removing the suffix on ZIP+4 patterns"
function removezipsuffix()::ZipCodeCleaner
  ZipCodeCleaner("Z+4 Suffix", r"-[0-9]{1,4}", x -> string(split(x,"-")[1]))
end

"Returns a ZipCodeCleaner for padding left zeros to ensure ZIP code is 5 digits"
function padleftzeros()::ZipCodeCleaner
  ZipCodeCleaner("Left Zeros", r"^[0-9]{1,4}$", x -> lpad(x, 5, "0"))
end

"""
```julia
cleanzipcode(
  Zip::ZipCodeStr,
  cleaner::ZipCodeCleaner
)
```

Executes `cleaner.cleanfun` on `Zip` when `Zip` matches `cleaner.pattern`.
"""
function cleanzipcode!(Zip::ZipCodeStr, cleaner::ZipCodeCleaner)::AbstractString
  Zip.val = ismatch(cleaner.pattern, Zip.val) ? cleaner.cleanfun(Zip.val) : Zip.val
end

"""
```julia
cleanzipcode(
    Zip::AbstractString;
    whitespace::Bool=true,      # Remove leading/trailing whitespace
    suffix::Bool=true,          # Remove "Z-{4}" suffix
    padzeros::Bool=true,        # Pad left zeros
    returnNA::Bool=true,        # Return unrecognized values as NA
    enforcestring::Bool=false   # Ensure return values are Strings
)
```

Description
===========
Returns `Zip` as an AbstractString with the following default corrections:
* Leading and trailing whitespace removed
* Z+4 suffix removed (e.g. 99999-1234 → 99999)
* Padded for left zeros(e.g. 245 → 00245)

If `Zip` does not match the "12345" pattern even after the above
corrections an NA value will be returned by default.

Usage
=====
```julia
cleanzipcode("01234 ")
cleanzipcode("1234")
cleanzipcode("1234-0000")
cleanzipcode("notaZip")
cleanzipcode("notaZip", enforcestring=true)
```
"""
function cleanzipcode(
            Zip::AbstractString;
            whitespace::Bool=true,      # Remove leading/trailing whitespace
            suffix::Bool=true,          # Remove "Z-{4}" suffix
            padzeros::Bool=true,        # Pad left zeros
            returnNA::Bool=true,        # Return unrecognized values as NA
            enforcestring::Bool=false   # Ensure return type is a String
          )::StringNA
  if ismatch(PATTERN_ZIPCODE, Zip)
    return Zip
  else
    # Clean routine
    Zip = ZipCodeStr(Zip)
    if whitespace cleanzipcode!(Zip, removewhitespace()) end
    if suffix cleanzipcode!(Zip, removezipsuffix()) end
    if padzeros cleanzipcode!(Zip, padleftzeros()) end

    # Return routine
    if ismatch(PATTERN_ZIPCODE, Zip.val)
      return Zip.val
    else
      return returnNA ? enforcestring ? "NA" : NA : Zip.val
    end

  end
end

function cleanzipcode(Zip::Any; args...)::StringNA
  cleanzipcode(string.(Zip); args...)
end

function cleanzipcode(Zip::AbstractVector; args...)::Vector{StringNA}
  [cleanzipcode(x) for x in Zip]
end
