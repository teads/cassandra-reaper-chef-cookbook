# Cassandra Reaper Cookbook

Repair service for Apache Cassandra: TLP Cassandra Reaper + Cassandra Reaper UI

See http://cassandra-reaper.io/

Should work on any Linux distro with **systemd**. Integration tests are run on Debian, Ubuntu and CentOS.

# Tests

Run the following command to run lint, unit tests and integration tests:
```
delivery local all
```

# TODO

 * Add attributes documentation
 * Test each storage backend
 * Make more cassandra-reaper.yaml settings overridable via attributes

