# frozen_string_literal: true

require 'serverspec'
require 'spec_helper'

describe "Local Database Installation" do
  context "when the 'local_database' variable is set" do
    context "and it's set to true" do
      it 'installs PostgreSQL 9.6' do
        expect(package('postgresql-9.6')).to be_installed
      end
    end
  end
end
