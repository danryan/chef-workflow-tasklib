require 'chef-workflow/task-helpers/with_scheduler'

namespace :chef_server do
  desc "Create a chef server with the #{ChefWorkflow::GeneralSupport.machine_provisioner} provisioner"
  task :create => [ "chef:clean" ] do
    chef_workflow_task 'bootstrap/db'
    Rake::Task["bootstrap:db"].invoke

    # FIXME not really happy with having to repeat this at the end, but it's
    # necessary. maybe a subroutine in the right place in the future is the
    # best approach, but I'm feeling lazy right now.
    ChefWorkflow::KnifeSupport.build_knife_config

    with_scheduler do |s|
      s.serial = true
      s.schedule_provision(
        'chef-server', 
        [
          ChefWorkflow::GeneralSupport.machine_provisioner.new('chef-server', 1), 
          ChefWorkflow::VM::ChefServerProvisioner.new
        ],
        []
      )

      s.run
      s.wait_for('chef-server') # probably superfluous
    end

    # now that our chef server exists, re-bootstrap the config for future tasks
    ChefWorkflow::KnifeSupport.build_knife_config
    Chef::Config.from_file(ChefWorkflow::KnifeSupport.knife_config_path)
  end

  desc "Destroy the chef server"
  task :destroy do
    with_scheduler do |s|
      s.serial = true
      s.force_deprovision = true
      s.teardown_group('chef-server')
    end
  end
end
