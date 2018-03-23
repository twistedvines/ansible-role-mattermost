require 'serverspec'
require 'net/ssh'
require 'json'
require 'open3'
require 'docker-api'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options

module Util
  def self.project_dir
    File.expand_path "#{File.dirname(__FILE__)}/../../"
  end

  def self.docker_image_name
    'ansible-twistedvines-mattermost:test'
  end

  def self.build_docker_image
    return get_docker_image if @image_built
    Open3.popen3(
      "#{project_dir}/build.bash -b packer" \
      " -o docker -e test -v #{vars_json_path}"
    ) do |stdin, stdout, stderr, thread|
      unless thread.value.success?
        puts stdout.read
        puts stderr.read
        raise 'Failed to build docker image'
      end
    end
    @image_built = true
    get_docker_image
  end

  def self.get_docker_image
    image = ::Docker::Image.all.select do |image|
      image.info.dig('RepoTags').include? docker_image_name
    end.first
    raise 'Failed to find docker image' unless image
    image
  end

  def self.build_vars_json(variables)
    File.open(vars_json_path, 'w') do |file|
      file.write(JSON.generate(variables))
    end
  end

  def self.reset_vars_json
    File.open(vars_json_path, 'w') do |file|
      file.write(JSON.generate({}))
    end
  end

  private

  def self.vars_json_path
    "#{project_dir}/serverspec/spec/mocks/variables.json"
  end
end

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
