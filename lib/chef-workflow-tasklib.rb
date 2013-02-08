require 'chef-workflow'

module ChefWorkflow
  module TaskHelper
    def chef_workflow_task(obj)
      require "chef-workflow/tasks/#{obj}"
    end
  end
end

class << eval("self", TOPLEVEL_BINDING)
  include ChefWorkflow::TaskHelper
end

if defined? Rake::DSL
  module Rake::DSL
    include ChefWorkflow::TaskHelper
  end
end
