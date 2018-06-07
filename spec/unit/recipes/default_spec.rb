#
# Cookbook Name:: reaper
# Spec:: default
#
# Copyright (c) 2018 Teads, All Rights Reserved.

require 'spec_helper'

describe 'cassandra-reaper::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    %w(
      /opt/cassandra-reaper/default/conf
      /var/log/cassandra-reaper
    ).each do |dir|
      it "creates #{dir} directory" do
        expect(chef_run).to create_directory(dir).with(
          mode: '0755',
          owner: 'reaper',
          group: 'reaper'
        )
      end
    end

    it 'creates YAML configuration file' do
      yaml_conf = '/opt/cassandra-reaper/default/conf/cassandra-reaper.yaml'
      expect(chef_run).to render_file(yaml_conf)
      expect(chef_run).to create_template(yaml_conf).with(
        mode: '0644',
        owner: 'reaper',
        group: 'reaper'
      )
    end

    it 'creates /etc/cassandra-reaper directory' do
      expect(chef_run).to create_directory('/etc/cassandra-reaper').with(
        mode: '0755',
        owner: 'reaper',
        group: 'reaper'
      )
    end

    it 'creates systemd service file' do
      service_file = '/lib/systemd/system/cassandra-reaper.service'
      expect(chef_run).to render_file(service_file)
      expect(chef_run).to create_template(service_file).with(
        mode: '0644',
        owner: 'root',
        group: 'root'
      )
    end
  end
end
