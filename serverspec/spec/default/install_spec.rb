# frozen_string_literal: true

require 'serverspec'
require 'spec_helper'

describe "System Preparation" do
  it 'Ensures the system is up to date' do
    expect(upgrade_status)
      .to match(/0 upgraded, 0 newly installed/)
  end

  describe package('ca-certificates') do
    it { should be_installed }
  end

  describe 'Mattermost user and group' do
    describe user('mattermost') do
      it { should exist }
      it { should belong_to_group('mattermost') }
    end

    describe group('mattermost') do
      it { should exist }
    end
  end

  describe 'Mattermost Installation' do
    describe file('/opt/mattermost') do
      it { should be_directory }
      it { should be_owned_by('mattermost') }
      it { should be_grouped_into('mattermost') }
      it { should be_writable.by('group') }
    end

    describe file('/opt/mattermost/data') do
      it { should be_directory }
    end

    it 'should be version 4.3.0' do
      expect(mattermost_version)
        .to match(/Version: 4.3.0/)
    end
  end

  def upgrade_status
    command('apt upgrade').stdout
  end

  def mattermost_version
    command('su mattermost -c "cd /opt/mattermost && ./bin/platform version"').stdout
  end
end
