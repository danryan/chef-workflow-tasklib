require 'knife/dsl'
require 'chef-workflow/tasks/bootstrap/knife'

namespace :chef do
  namespace :environments do
    desc "Upload your environments to the chef server"
    task :upload => [ "bootstrap:knife" ] do
      if File.directory?(ChefWorkflow::KnifeSupport.environments_path)
        env_upload = lambda do |files|
          files = [files] unless files.kind_of?(Array)
          status = knife %W[environment from file] + files
          fail if status != 0
        end

        environment_files = Dir[File.join(ChefWorkflow::KnifeSupport.environments_path, '*.{rb,js,json}')]

        if Chef::VERSION < '10.16'
          environment_files.each { |file| env_upload.call(file) }
        else
          env_upload.call(environment_files)
        end
      end
    end
  end
end
