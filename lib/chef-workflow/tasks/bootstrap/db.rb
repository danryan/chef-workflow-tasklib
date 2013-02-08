namespace :bootstrap do
  task :db do
    require 'chef-workflow/support/db'
    ChefWorkflow::DatabaseSupport.instance.reconnect
    ChefWorkflow::IPSupport.create_table
  end
end
