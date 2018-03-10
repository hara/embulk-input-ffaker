# FFaker input plugin for Embulk

Embulk input plugin for fake data with [ffaker].

## Overview

* **Plugin type**: input
* **Resume supported**: no
* **Cleanup supported**: no
* **Guess supported**: no

## Configuration

- **rows**: number of generated rows (integer, required)
- **schema**: column definitions (array, required)
  - **name**: column name (string, required)
  - **module**: module name of FFaker (see [reference](https://github.com/ffaker/ffaker/blob/master/REFERENCE.md)) (string, optional)
  - **method**: method name of FFaker module (string, required if module is specified)
  - **parameters**: method parameter list (array, default: [])
  - **random**: generates random number with FFaker::Random.rand (optional)
    - **min**: min value of number (optional)
    - **max**: max value of number (optional)

## Example

```yaml
in:
  type: ffaker
  rows: 100
  schema:
  - name: street
    module: AddressUS
    method: street_name
  - name: createdAt
    module: Time
    method: datetime
    parameters:
    - year_range: 2
  - name: double1
    random: nil # this invokes FFaker::Random.rand
  - name: long1
    random:
      max: 10  # this invokes FFaker::Random.rand(10)
  - name: long2
    random:  # this invokes FFaker::Random.rand(-10..10)
      min: -10
      max: 10
```


## Build

```
$ rake
```

[ffaker]: https://rubygems.org/gems/ffaker