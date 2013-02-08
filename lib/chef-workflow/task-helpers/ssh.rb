require 'chef-workflow/support/ssh'

if defined? Rake::DSL
  module Rake::DSL
    include ChefWorkflow::SSHHelper
  end
end

class << eval('self', TOPLEVEL_BINDING)
  include ChefWorkflow::SSHHelper
end
