# Cassandra Reaper Cookbook

Repair service for Apache Cassandra: TLP Cassandra Reaper + Cassandra Reaper UI

See http://cassandra-reaper.io/

Should work on any Linux distro with **systemd**. Integration tests are run on Debian, Ubuntu and CentOS.


# Attributes

## General Reaper settings

* `['reaper']['conf']['segmentCount']`: Number of repair segments to create for newly registered Cassandra repair runs, for each node in the cluster. When running a repair run by Reaper, each segment is repaired separately by the Reaper process, until all the segments in a token ring are repaired. The count might be slightly off the defined value, as clusters residing in multiple data centers require additional small token ranges in addition to the expected. (default: `200`)
* `['reaper']['conf']['repairParallelism']`: Parallelism to apply by default to repair runs
 * `DATACENTER_AWARE` (default): one replica in each DC at the same time, with snapshots. Cassandra >= 2.0.12.
 * `PARALLEL`: all replicas at the same time, no snapshot
 * `SEQUENTIAL`: one replica at a time, validation compaction performed on snapshots
* `['reaper']['conf']['repairIntensity']`: must be a value between 0.0 and 1.0, but not 0.
amount of time to sleep between triggering each repair segment while running a repair run. When intensity is 1.0, it means that Reaper does not sleep at all before triggering next segment, and otherwise the sleep time is defined by how much time it took to repair the last segment divided by the intensity value. 0.5 means half of the time is spent sleeping, and half running. Intensity 0.75 means that 25% of the total time is used sleeping and 75% running. (default: `0.9`)
* `['reaper']['conf']['scheduleDaysBetween']`:Amount of days to wait between scheduling new repairs. Set to `0` for continuous repairs.
(default: `7`)
* `['reaper']['conf']['repairRunThreadCount']`: Number of threads to use for handling the Reaper tasks. Have this big enough not to cause
blocking in case some threads are waiting for I/O, like calling a Cassandra cluster through JMX. (default: `15`)
* `['reaper']['conf']['hangingRepairTimeoutMins']`: (default: `30`)
* `['reaper']['conf']['incrementalRepair']`: To enable Incremental Repair (default: `false`)
* `['reaper']['conf']['repairManagerSchedulingIntervalSeconds']`: Controls the pace at which the Repair Manager will schedule processing of the next segment (default: `10`)
* `['reaper']['conf']['datacenterAvailability']`:
  * `ALL` (default): if Reaper has access to all node jmx ports, across all datacenters.
  * `LOCAL` if jmx access is only available to nodes in the same datacenter as Reaper in running in.
  * `EACH` if there is a Reaper instance running in every datacenter.

 There are other attributes for general settings see [attributes/default.rb](./attributes/default.rb)

## Storage backends

Choose your backend, `memory` should be used for testing purpose only:

* `node['reaper']['conf']['storageType']`: Backend to persist Reaper state. Can be 'cassandra', 'h2', 'memory', or 'postgres' (default: `'memory'`)

### PostgreSQL or h2

Credentials and data source name JDBC:

 * `node['reaper']['database']['url']`: JDBC data source name `'jdbc:<(postgresql|h2)>://<Database IP or DNS>/<Database name>'` (default: `'jdbc:postgresql://127.0.0.1/reaper_db'`)
 * `node['reaper']['database']['user']`: Username (default: `'reaper'`)
 * `node['reaper']['database']['password']`: Password

### Cassandra

Main attributes:

 * `node['reaper']['cassandra']['clusterName']`: Name of the cluster to use to store Reaper data
 * `node['reaper']['cassandra']['contactPoints']`: Seed nodes in the Cassandra cluster to contact (default: `['127.0.0.1']`)
 * `node['reaper']['cassandra']['keyspace']`: Name of the keyspace to store Reaper data (default: `'reaper_db'`)
 * `node['reaper']['cassandra']['loadBalancingPolicy']['subPolicy']['type']`: Load Balancing policy (default: `'dcAwareRoundRobin'`)
 * `node['reaper']['cassandra']['loadBalancingPolicy']['subPolicy']['localDC']`: Name of the datacenter closest to Reaper when using the `'dcAwareRoundRobin'` policy
 * `node['reaper']['cassandra']['authProvider']['username']`: Cassandra native protocol username (default: `'cassandra'`)
 * `node['reaper']['cassandra']['authProvider']['password']`: Cassandra native protocol password (default: `'cassandra'`)

 There are other attributes for Cassandra, see [attributes/default.rb](./attributes/default.rb)

## Reaper Autoscheduling

 * `node['reaper']['autoScheduling']['enabled']`: Automatically setup repair schedules for all non-system keyspaces in a cluster (default: `false`).
 * `node['reaper']['autoScheduling']['initialDelayPeriod']`: Time before the schedule period starts (default: `'PT15S'`)
 * `node['reaper']['autoScheduling']['periodBetweenPolls']`: Time to wait before checking whether to start a repair task (default: `'PT10M'`)
 * `node['reaper']['autoScheduling']['timeBeforeFirstSchedule']`: Grace period before the first repair in the schedule is started (default: `'PT5M'`)
 * `node['reaper']['autoScheduling']['scheduleSpreadPeriod']`: Time spacing between each of the repair schedules that is to be carried out (default: `'PT6H'`)
 * `node['reaper']['autoScheduling']['excludedKeyspaces']`: Keyspaces that are to be excluded from the repair schedule (default: `[]`)

For more information see http://cassandra-reaper.io/docs/configuration/reaper_specific/

## Java

By default Oracle JDK 8 is installed. If you don't want to install Java set the following attribute:
 * `node['reaper']['install_java']` = false

The cookbook uses `java` cookbook so you can easily tweak installation. Here are attributes set by default:

```
node['java']['jdk_version'] = 8
node['java']['install_flavor'] = 'oracle'
node['java']['oracle']['accept_oracle_download_terms'] = true
```

See [Java cookbook](https://github.com/sous-chefs/java) for more details.

### JMX

 * `node['reaper']['jmx']['auth_enabled']`: Is JMX authentication is enabled on Cassandra nodes? (default `false`)
 * `node['reaper']['jmx']['username']`: JMX username
 * `node['reaper']['jmx']['password']`: JXM password

 There are other attributes for JMX, see [attributes/default.rb](./attributes/default.rb)

## Linux

 * `node['reaper']['base_directory']`: Directory where Cassandra reaper tarball will be extracted (default: `'/opt/cassandra-reaper'`)
 * `node['reaper']['user']`: Linux user (default: `'reaper'`)
 * `node['reaper']['group']`: Linux group (default: `'reaper'`)


# Tests

Run the following command to run lint, unit tests and integration tests:
```
delivery local all
```

# TODO

 * Test each storage backend
 * Make more cassandra-reaper.yaml settings overridable via attributes

