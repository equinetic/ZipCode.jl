# TODO

### Docs/Integrity

- [x] Further inline documentation of functions, API
- [ ] Readthedocs
- [ ] Write tests for distance formulas
- [x] Add sources to README

### General

- [x] Implement algorithms for more accurate distance calculations

    **>> vincenty iterative algorithm**
- [ ] Create way for users to access expected error rate of distance calcs
- [x] Build out convenience functions for quicker/easier access of subsets and
  relevant vector operations

    **>> Ongoing, but made improvements**
- [ ] Quicker way to run distance calcs on subsets. Maybe something like:
  `distance(zipcodeA, zipcodeB)`

- [ ] Ability to return closest match(es) given lat/long coordinates
- [ ] Ability to query via distance tolerance
- [x] Make `cleanzipcode` more flexible

    **>> Converted cleaning routines into optional, standalone functions**
- [ ] Add unit return type to distance calculations

### Long Term

- [ ] Further build out of the current data set: detailed edges of counties, states, etc; additional geographic features
- [ ] Use as a starting point for a wider-scoped geodata package (more than just U.S.)
- [ ] Possibly integrate with other Julia geo-related orgs/packages as needed
