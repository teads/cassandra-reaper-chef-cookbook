name             'cassandra-reaper'
maintainer       'Teads'
maintainer_email 'romain.hardouin@teads.tv'
license          'Apache-2.0'
description      'Installs Cassandra Reaper, a repair service for Apache Cassandra'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'
chef_version     '>= 12'

source_url 'https://github.com/teads/cassandra-reaper-chef-cookbook'
issues_url 'https://github.com/teads/cassandra-reaper-chef-cookbook/issues'

%w(ubuntu debian redhat centos).each do |os|
  supports os
end

depends 'java'
depends 'tar'
