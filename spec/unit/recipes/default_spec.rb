#
# Cookbook Name:: reaper
# Spec:: default
#
# Copyright (c) 2018 Teads, All Rights Reserved.

require 'spec_helper'

VERSION = '1.1.0'.freeze

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
      /opt/cassandra-reaper
      /opt/cassandra-reaper/default/conf
      /var/log/cassandra-reaper
      /etc/cassandra-reaper
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

    it 'creates /etc/cassandra-reaper/cassandra-reaper.yaml symlink' do
      expect(chef_run).to create_link('/etc/cassandra-reaper/cassandra-reaper.yaml')
      link = chef_run.link('/etc/cassandra-reaper/cassandra-reaper.yaml')
      expect(link).to link_to('/opt/cassandra-reaper/default/conf/cassandra-reaper.yaml')
    end

    it 'creates /opt/cassandra-reaper/default symlink' do
      expect(chef_run).to create_link('/opt/cassandra-reaper/default')
      link = chef_run.link('/opt/cassandra-reaper/default')
      expect(link).to link_to(%r{/opt/cassandra-reaper/cassandra-reaper-\d\.\d\.\d})
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

    it 'enables service' do
      expect(chef_run).to enable_service('cassandra-reaper')
    end

    it 'enables service' do
      expect(chef_run).to start_service('cassandra-reaper')
    end

    it 'create the reaper user' do
      expect(chef_run).to create_user('reaper').with(
        home: '/home/reaper',
        shell: '/bin/bash',
        system: true
      )
    end

    it 'extracts reaper tarball' do
      expect(chef_run).to extract_tar_extract("https://github.com/thelastpickle/cassandra-reaper/releases/download/#{VERSION}/cassandra-reaper-#{VERSION}-release.tar.gz")
    end

    it 'chown install directory after tarball extraction' do
      expect(chef_run.tar_extract("https://github.com/thelastpickle/cassandra-reaper/releases/download/#{VERSION}/cassandra-reaper-#{VERSION}-release.tar.gz")).to notify('execute[chown-reaper-directory]').to(:run).delayed
    end

    it 'does not chown install directory prior to extract tarball' do
      script = chef_run.execute('chown-reaper-directory')
      expect(script).to do_nothing
    end
  end
end
