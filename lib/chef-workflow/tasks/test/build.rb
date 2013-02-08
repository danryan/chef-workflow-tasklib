require 'chef-workflow/tasks/test'
require 'chef-workflow/tasks/chef/upload'
require 'chef-workflow/tasks/chef/clean'

namespace :test do
  desc "chef:upload and test"
  task :build => [
    "chef:upload",
    "test"
  ]

  desc "chef:clean:machines and test:build"
  task :rebuild => [
    "chef:clean:machines",
    "test:build"
  ]

  desc "Build a chef server, run test:build, destroy the chef server"
  task :full => [
    "chef_server:create",
    "test:build",
    "test:recipes"
  ] do
    # hack to get chef:clean to run again
    (Rake::Task["chef:clean"].prerequisite_tasks + [Rake::Task["chef:clean"]]).each(&:reenable)
    Rake::Task["chef:clean"].invoke
  end
end
