# Testing

## Test Suites

The easier way to run all tests is to use Chef Delivery.
`all` will run lint, unit tests and integration tests:

```
$ delivery local all
```

## Kitchen

You can also use Kitchen to run integration tests:

```
$ kitchen destroy && kitchen verify
```

To run only one test suite:

```
$ kitchen verify default-debian-94
```

To list test suites:
```
$ kitchen list
Instance             Driver   Provisioner  Verifier  Transport  Last Action  Last Error
default-debian-94    Vagrant  ChefZero     Inspec    Ssh        Created      <None>
default-ubuntu-1804  Vagrant  ChefZero     Inspec    Ssh        Created      <None>
default-centos-74    Vagrant  ChefZero     Inspec    Ssh        Created      <None>
```

Note that you can ssh on one instance:
```
$ kitchen login default-debian-94
```

## rake tasks

 * `rake default` Run linter, unit tests and integration tests
 * `rake foodcritic` Run foodcritic linter
 * `rake integration` Run integration tests with kitchen-vagrant
 * `rake spec` Run ChefSpec
 * `rake unit` Run linter and unit tests
