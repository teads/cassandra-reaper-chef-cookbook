#
# Cookbook Name:: cassandra-reaper
# Recipe:: default
#
# Copyright 2018, Teads
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java' if node['reaper']['install_java']

user node['reaper']['user'] do
  comment 'Cassandra Reaper user,,,'
  home "/home/#{node['reaper']['user']}"
  manage_home true
  shell '/bin/bash'
  system true
end

# Cassandra reaper installation
#
[
  node['reaper']['base_directory'],
  node['reaper']['log_directory'],
].each do |dir|
  directory dir do
    owner node['reaper']['user']
    group node['reaper']['group']
    mode '0755'
    recursive true
  end
end

tar_extract node['reaper']['url'] do
  target_dir node['reaper']['base_directory']
  creates "#{node['reaper']['base_directory']}/cassandra-reaper-#{node['reaper']['version']}/bin/cassandra-reaper"
  notifies :run, 'execute[chown-reaper-directory]', :delayed
end

execute 'chown-reaper-directory' do
  command "chown -R #{node['reaper']['user']}:#{node['reaper']['user']} #{node['reaper']['base_directory']}"
  user 'root'
  action :nothing
end

link node['reaper']['directory'] do
  to "#{node['reaper']['base_directory']}/cassandra-reaper-#{node['reaper']['version']}"
end

# YAML configuration file
#
directory "#{node['reaper']['directory']}/conf" do
  owner node['reaper']['user']
  group node['reaper']['group']
  mode '0755'
  recursive true
end

template "#{node['reaper']['directory']}/conf/cassandra-reaper.yaml" do
  source 'cassandra-reaper.yaml.erb'
  mode   '0644'
  owner node['reaper']['user']
  group node['reaper']['user']
end

directory '/etc/cassandra-reaper' do
  owner node['reaper']['user']
  group node['reaper']['group']
  mode '0755'
end

link '/etc/cassandra-reaper/cassandra-reaper.yaml' do
  to "#{node['reaper']['directory']}/conf/cassandra-reaper.yaml"
end

# systemd service
#
template '/lib/systemd/system/cassandra-reaper.service' do
  source 'cassandra-reaper.service'
  mode   '0644'
  owner 'root'
  group 'root'
end

service 'cassandra-reaper' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
  provider Chef::Provider::Service::Systemd
end
