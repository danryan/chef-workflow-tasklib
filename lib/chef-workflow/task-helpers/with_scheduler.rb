require 'chef-workflow/support/general'
require 'chef-workflow/support/ip'
require 'chef-workflow/support/vagrant'
require 'chef-workflow/support/ec2'
require 'chef-workflow/support/knife'
require 'chef-workflow/support/scheduler'
require 'chef/config'

if defined? Rake::DSL
  module Rake::DSL
    def with_scheduler
      if File.exist?(ChefWorkflow::KnifeSupport.knife_config_path)
        Chef::Config.from_file(ChefWorkflow::KnifeSupport.knife_config_path)
        s = ChefWorkflow::Scheduler.new
        yield s
        s.stop
      end
    end
  end
end
