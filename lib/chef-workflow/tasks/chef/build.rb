require 'chef-workflow/task-helpers/with_scheduler'
require 'chef-workflow/support/vm/helpers/knife'

namespace :chef do
  desc "build and bootstrap a machine with a role in the run_list"
  task :build, :role_name, :number_of_machines do |task, args|
    unless args[:role_name]
      raise 'You must supply a role name to chef:build'
    end

    role_name          = args[:role_name]
    number_of_machines = (args[:number_of_machines] || 1).to_i

    with_scheduler do |s|
      kp = build_knife_provisioner
      kp.solr_check = false

      s.schedule_provision(
        role_name,
        [
          ChefWorkflow::GeneralSupport.machine_provisioner.new(
            role_name,
            number_of_machines
          ),
          kp
        ],
        []
      )

      s.run
      s.wait_for(role_name)
    end
  end
end
