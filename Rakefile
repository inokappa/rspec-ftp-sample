require 'rake'
require 'rspec/core/rake_task'
require 'yaml'
 
properties = YAML.load_file('secret.yml')
 
namespace :ftpcheck do
  properties.keys.each do |host|
    namespace host.to_sym do
      properties[host]['users'].each do |user|
        ftpuser = user['username']
        desc "Run ftpcheck to #{host} by #{ftpuser}"
        RSpec::Core::RakeTask.new(ftpuser.to_sym) do |t|
          ENV['TARGET_HOST'] = host
          ENV['FTP_USER'] = ftpuser
          t.pattern = 'spec/ftp_spec.rb'
        end
      end
    end
  end
end
