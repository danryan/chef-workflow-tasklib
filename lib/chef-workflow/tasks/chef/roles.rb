require 'knife/dsl'
require 'chef-workflow/tasks/bootstrap/knife'

namespace :chef do
  namespace :roles do
    desc "Upload your roles to the chef server"
    task :upload => [ "bootstrap:knife" ] do
      if File.directory?(ChefWorkflow::KnifeSupport.roles_path)
        status = knife %W[role from file] + Dir[File.join(ChefWorkflow::KnifeSupport.roles_path, '*.{rb,js,json}')]
        fail if status != 0
      end
    end
  end
end
