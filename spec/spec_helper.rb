require 'rspec'
require 'rspec-ftp'
require 'specinfra/properties'
require 'yaml'

def property
  Specinfra::Properties.instance.properties
end

def set_property(prop)
  Specinfra::Properties.instance.properties(prop)
end

properties = YAML.load_file('secret.yml')
host = ENV['TARGET_HOST']
ftpuser = ENV['FTP_USER']
set_property properties[host]['users'].first {|u| u['username'] == ftpuser }
