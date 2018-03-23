# frozen_string_literal: true

require 'serverspec'
require 'spec_helper'

describe "No Local Database Installation" do
  let!(:image) { Util.build_docker_image }
  let(:vars) { {} }

  before do
    Util.build_vars_json(vars)
    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
  end

  context "when the 'local_database' variable is set" do
    context "and it's set to false" do
      let(:vars) do
        {
          'local_database' => false,
          'postgresql_service_enabled' => false
        }
      end

      it 'does not install PostgreSQL 9.6' do
        expect(package('postgresql-9.6')).not_to be_installed
      end
    end
  end

  after do
    Util.reset_vars_json
  end
end
