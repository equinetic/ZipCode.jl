# TODO
- [ ] Readthedocs
- [ ] Write tests for distance formulas to verify calculations
- [ ] 0.6
- [ ] Create way for users to access expected error rate of distance calcs
- [ ] Distance searches
  - [ ] Convenience function for subsets `distance(zipA, zipB)`
  - [ ] Closest matches given (lat, long), city, zip, etc. `findmatch(zip="1234", tolerance=50, returnclosest=5)`
- [ ] Further build out of the current data set: detailed edges of counties, states, etc; additional geographic features
- [ ] Use as a starting point for a wider-scoped geodata package (more than just U.S.)
- [ ] Possibly integrate with other Julia geo-related orgs/packages as needed

### Completed
- [x] Further inline documentation of functions, API
- [x] Add sources to README
- [x] Better test coverage
- [x] Implement algorithms for more accurate distance calculations
- [x] Build out convenience functions for quicker/easier access of subsets and
  relevant vector operations
- [x] Make `cleanzipcode` more flexible
- [x] Add unit return type to distance calculations
