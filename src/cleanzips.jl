mutable struct ZipCodeStr
    val::String
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
    name::String
    pattern::Regex
    cleanfun::Function
end

"Returns a ZipCodeCleaner for stripping whitespace"
removewhitespace() = ZipCodeCleaner("Whitespace", r"[ ]*", x -> strip(x))

"Returns a ZipCodeCleaner for removing the suffix on ZIP+4 patterns"
removezipsuffix() = ZipCodeCleaner("Z+4 Suffix", r"-[0-9]{1,4}", x -> string(split(x,"-")[1]))

"Returns a ZipCodeCleaner for padding left zeros to ensure ZIP code is 5 digits"
padleftzeros() = ZipCodeCleaner("Left Zeros", r"^[0-9]{1,4}$", x -> lpad(x, 5, "0"))

"""
```julia
cleanzipcode(
  zip::ZipCodeStr,
  cleaner::ZipCodeCleaner
)
```

Executes `cleaner.cleanfun` on `zip` when `zip` matches `cleaner.pattern`.
"""
function cleanzipcode!(zip::ZipCodeStr, cleaner::ZipCodeCleaner)
    occursin(cleaner.pattern, zip.val) && (zip.val = cleaner.cleanfun(zip.val))
    zip
end

"""
```julia
cleanzipcode(
    zip::AbstractString;
    whitespace::Bool=true,      # Remove leading/trailing whitespace
    suffix::Bool=true,          # Remove "Z-{4}" suffix
    padzeros::Bool=true,        # Pad left zeros
    returnNA::Bool=true,        # Return unrecognized values as NA
    enforcestring::Bool=false   # Ensure return values are Strings
)
```

Description
===========
Returns `zip` as an AbstractString with the following default corrections:
* Leading and trailing whitespace removed
* Z+4 suffix removed (e.g. 99999-1234 → 99999)
* Padded for left zeros(e.g. 245 → 00245)

If `zip` does not match the "12345" pattern even after the above
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
function cleanzipcode(str::AbstractString;
                      whitespace::Bool=true,      # Remove leading/trailing whitespace
                      suffix::Bool=true,          # Remove "Z-{4}" suffix
                      padzeros::Bool=true,        # Pad left zeros
                      returnNA::Bool=true,        # Return unrecognized values as NA
                      enforcestring::Bool=false)  # Ensure return type is a String

    occursin(PATTERN_ZIPCODE, str) && return str

    # Clean routine
    zip = ZipCodeStr(str)
    whitespace && cleanzipcode!(zip, removewhitespace())
    suffix && cleanzipcode!(zip, removezipsuffix())
    padzeros && cleanzipcode!(zip, padleftzeros())

    # Return routine
    ((occursin(PATTERN_ZIPCODE, zip.val) || !returnNA)
     ? zip.val
     : (enforcestring ? "NA" : missing))
end

cleanzipcode(zip::Any; kwargs...) = cleanzipcode(string.(zip); kwargs...)

cleanzipcode(zip::AbstractVector; kwargs...) = StringNA[cleanzipcode(x; kwargs...) for x in zip]
