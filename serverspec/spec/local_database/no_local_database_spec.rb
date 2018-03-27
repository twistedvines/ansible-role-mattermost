# frozen_string_literal: true

require 'serverspec'
require 'spec_helper'

describe "No Local Database Installation" do
  context "when the 'local_database' variable is set" do
    context "and it's set to false" do
      it 'does not install PostgreSQL 9.6' do
        expect(package('postgresql-9.6')).not_to be_installed
      end
    end
  end
end
