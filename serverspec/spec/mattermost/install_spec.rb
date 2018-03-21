# frozen_string_literal: true

require 'serverspec'
require 'spec_helper'

describe "Packer Docker build" do
  let(:image_name) { 'ansible-twistedvines-mattermost:test' }

  before do
    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image_name

    Util.build_docker_image
  end

  it 'Ensures the system is up to date' do
    expect(upgrade_status)
      .to match(/0 upgraded, 0 newly installed/)
  end

  def upgrade_status
    command('apt upgrade').stdout
  end
end
