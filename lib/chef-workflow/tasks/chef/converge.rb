require 'chef-workflow/task-helpers/ssh'

namespace :chef do
  desc "run chef-client on a group of machines"
  task :converge, :role_name do |task, args|
    unless args[:role_name]
      raise "You must supply a node name to converge"
    end

    ssh_role_command(args[:role_name], 'chef-client')
  end
end
