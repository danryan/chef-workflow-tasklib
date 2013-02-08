chef_workflow_task 'chef/data_bags'
chef_workflow_task 'chef/environments'
chef_workflow_task 'chef/roles'
chef_workflow_task 'chef/cookbooks/upload'

namespace :chef do
  desc "Upload everything."
  task :upload => %w[
    chef:cookbooks:upload
    chef:roles:upload
    chef:environments:upload
    chef:data_bags:upload
  ]
end
