require 'chef-workflow/task-helpers/with_scheduler'
require 'fileutils'

namespace :chef do
  namespace :clean do
    desc "Clean up the machines that a previous chef-workflow run generated"
    task :machines do
      with_scheduler do |s|
        s.serial = true
        s.force_deprovision = true
        s.teardown(%w[chef-server])
      end
    end
  end

  desc "Clean up the entire chef-workflow directory and machines"
  task :clean => [ "chef:clean:machines", "chef_server:destroy" ] do
    ChefWorkflow::EC2Support.destroy_security_group
    FileUtils.rm_rf(ChefWorkflow::GeneralSupport.workflow_dir)
  end
end
