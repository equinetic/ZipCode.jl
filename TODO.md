# TODO

### Docs/Integrity

- [x] Further inline documentation of functions, API
- [ ] Readthedocs
- [ ] Write tests for distance formulas (to verify calculations)
- [x] Add sources to README
- [x] Better test coverage
- [ ] Prep for 0.6+

### General

- [x] Implement algorithms for more accurate distance calculations

    **>> vincenty iterative algorithm**
- [ ] Create way for users to access expected error rate of distance calcs
- [x] Build out convenience functions for quicker/easier access of subsets and
  relevant vector operations

    **>> Ongoing, but made improvements**
- [ ] Distance searches
  - [ ] Convenience function for subsets `distance(zipA, zipB)`
  - [ ] Closest matches given (lat, long), city, zip, etc. `findmatch(zip="1234", tolerance=50, returnclosest=5)`
- [x] Make `cleanzipcode` more flexible

    **>> Converted cleaning routines into optional, standalone functions**
- [ ] Add unit return type to distance calculations

### Long Term

- [ ] Further build out of the current data set: detailed edges of counties, states, etc; additional geographic features
- [ ] Use as a starting point for a wider-scoped geodata package (more than just U.S.)
- [ ] Possibly integrate with other Julia geo-related orgs/packages as needed
