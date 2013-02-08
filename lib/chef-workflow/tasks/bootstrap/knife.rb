require 'chef-workflow/support/knife'

namespace :bootstrap do
  task :knife do
    # this is what knife-dsl needs to know what config to use
    ENV["CHEF_CONFIG"] ||= ChefWorkflow::KnifeSupport.knife_config_path
  end
end
