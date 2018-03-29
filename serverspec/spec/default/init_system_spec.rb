# frozen_string_literal: true

require 'serverspec'
require 'spec_helper'

describe "Init System" do
  context 'when an init system is required' do
    describe file('/lib/systemd/system/mattermost.service') do
      it { should be_file }
      it { should be_owned_by('root') }
      its(:content) { should match /ExecStart=\/opt\/mattermost\/bin\/platform/ }
    end

    describe service('mattermost') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
