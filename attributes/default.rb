default['reaper']['version'] = '1.1.0'
default['reaper']['url'] = "https://github.com/thelastpickle/cassandra-reaper/releases/download/#{node['reaper']['version']}/cassandra-reaper-#{node['reaper']['version']}-release.tar.gz"

##################
# Linux Settings #
##################
default['reaper']['base_directory'] = '/opt/cassandra-reaper'
default['reaper']['directory'] = "#{node['reaper']['base_directory']}/default"
default['reaper']['log_directory'] = '/var/log/cassandra-reaper'
default['reaper']['user'] = 'reaper'
default['reaper']['group'] = 'reaper'

###################
# Reaper Settings #
###################
default['reaper']['conf']['segmentCount'] = 200
default['reaper']['conf']['repairParallelism'] = 'DATACENTER_AWARE' # SEQUENTIAL, PARALLEL, DATACENTER_AWARE
default['reaper']['conf']['repairIntensity'] = 0.9
default['reaper']['conf']['scheduleDaysBetween'] = 7
default['reaper']['conf']['repairRunThreadCount'] = 15
default['reaper']['conf']['hangingRepairTimeoutMins'] = 30
default['reaper']['conf']['storageType'] = 'memory' # cassandra, h2, memory, postgres
default['reaper']['conf']['enableCrossOrigin'] = true
default['reaper']['conf']['incrementalRepair'] = false
default['reaper']['conf']['enableDynamicSeedList'] = true
default['reaper']['conf']['repairManagerSchedulingIntervalSeconds'] = 10
default['reaper']['conf']['useAddressTranslator'] = false
default['reaper']['conf']['datacenterAvailability'] = 'ALL' # ALL, LOCAL, EACH

default['reaper']['autoScheduling']['enabled'] = false
default['reaper']['autoScheduling']['initialDelayPeriod'] = 'PT15S'
default['reaper']['autoScheduling']['periodBetweenPolls'] = 'PT10M'
default['reaper']['autoScheduling']['timeBeforeFirstSchedule'] = 'PT5M'
default['reaper']['autoScheduling']['scheduleSpreadPeriod'] = 'PT6H'
default['reaper']['autoScheduling']['excludedKeyspaces'] = []

####################################
# Reaper backend Specific Settings #
####################################

default['reaper']['database']['user'] = 'reaper'
default['reaper']['database']['password'] = 'secret'
default['reaper']['database']['url'] = 'jdbc:postgresql://127.0.0.1/reaper_db'

default['reaper']['cassandra']['clusterName'] = 'test'
default['reaper']['cassandra']['contactPoints'] = ['127.0.0.1']
default['reaper']['cassandra']['port'] = 9042
default['reaper']['cassandra']['keyspace'] = 'reaper_db'
default['reaper']['cassandra']['activateQueryLogger'] = false
default['reaper']['cassandra']['loadBalancingPolicy']['type'] = 'tokenAware'
default['reaper']['cassandra']['loadBalancingPolicy']['shuffleReplicas'] = true
default['reaper']['cassandra']['loadBalancingPolicy']['subPolicy']['type'] = 'dcAwareRoundRobin'
default['reaper']['cassandra']['loadBalancingPolicy']['subPolicy']['localDC'] = ''
default['reaper']['cassandra']['loadBalancingPolicy']['subPolicy']['usedHostsPerRemoteDC'] = 0
default['reaper']['cassandra']['loadBalancingPolicy']['subPolicy']['allowRemoteDCsForLocalConsistencyLevel'] = false
default['reaper']['cassandra']['queryOptions']['consistencyLevel'] = 'LOCAL_QUORUM'
default['reaper']['cassandra']['queryOptions']['serialConsistencyLevel'] = 'SERIAL'
default['reaper']['cassandra']['authProvider']['type'] = 'plainText'
default['reaper']['cassandra']['authProvider']['username'] = 'cassandra'
default['reaper']['cassandra']['authProvider']['password'] = 'cassandra'

########
# Java #
########

# JDK
#
default['reaper']['install_java'] = true
default['java']['jdk_version'] = 8
default['java']['install_flavor'] = 'oracle'
default['java']['oracle']['accept_oracle_download_terms'] = true

# JMX
#
default['reaper']['jmx']['auth_enabled'] = false
default['reaper']['jmx']['username'] = 'username'
default['reaper']['jmx']['password'] = 'password'
default['reaper']['jmx']['connection_timeout_seconds'] = 5
default['reaper']['jmx']['use_ports_mapping'] = false
default['reaper']['jmx']['ports_mapping'] = {
  '127.0.0.1' => 7100,
  '127.0.0.2' => 7200,
  '127.0.0.3' => 7300,
}
# TODO: support 'jmxCredentials' i.e. per cluster jmx credentials
