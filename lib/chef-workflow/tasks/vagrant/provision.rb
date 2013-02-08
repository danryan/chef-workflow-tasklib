require 'chef-workflow/support/knife'
require 'chef-workflow/support/vagrant'
require 'vagrant/dsl'

namespace :vagrant do
	desc 'provision running instances'
  task :provision do
  	vagrant 'provision'
  end
end
