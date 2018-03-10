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
  - name: street # invokes FFaker::AddressUS.street_name
    module: AddressUS
    method: street_name
  - name: createdAt # invokes FFaker::Time.datetime(year_range: 2)
    module: Time
    method: datetime
    parameters:
    - year_range: 2
  - name: double1 # invokes FFaker::Random.rand
    random: nil
  - name: long1 # invokes FFaker::Random.rand(10)
    random:
      max: 10
  - name: long2 # invokes FFaker::Random.rand(-10..10)
    random:
      min: -10
      max: 10
```


## Development

### Run example:

```
$ embulk bundle install --path vendor/bundle
$ embulk run -b . example/config.yaml
```


## Build

```
$ rake
```

[ffaker]: https://rubygems.org/gems/ffaker