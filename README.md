# Cassandra Reaper Cookbook

Repair service for Apache Cassandra: TLP Cassandra Reaper + Cassandra Reaper UI

See http://cassandra-reaper.io/

Should work on any Linux distro with **systemd**. Integration tests are run Debian, Ubuntu and CentOS.

# Tests

Run the following to run lint, unit tests and integration tests:
```
delivery local all
```

# TODO

 * Increase test coverage
 * Test each storage backend
 * Make more cassandra-reaper.yaml settings overridable via attributes
 
