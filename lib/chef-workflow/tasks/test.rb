require 'rake/testtask'
require 'chef-workflow/task-helpers/with_scheduler'
require 'chef-workflow/support/vm/helpers/knife'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir["test/**/test_*.rb"]
  t.verbose = true
end

namespace :test do
  desc "Test recipes in the test_recipes configuration."

  task :recipes => [ "test:recipes:cleanup" ] do
    with_scheduler do |s|
      s.run

      groups =
        ChefWorkflow::KnifeSupport.test_recipes.map do |recipe|
          group_name = "recipe-#{recipe.gsub(/::/, '-')}"

          kp            = build_knife_provisioner
          kp.run_list   = [ "recipe[#{recipe}]", "recipe[minitest-handler]" ]
          kp.solr_check = false

          s.schedule_provision(
            group_name,
            [
              ChefWorkflow::GeneralSupport.machine_provisioner.new(group_name, 1),
              kp
            ]
          )

          group_name
        end

      s.wait_for(*groups)

      groups.each do |group_name|
        s.teardown_group(group_name)
      end
    end
  end

  namespace :recipes do
    desc "Cleanup any stale instances created running recipe tests."
    task :cleanup do
      with_scheduler do |s|
        s.run

        s.vm_groups.select do |g, v|
          g.start_with?("recipe-")
        end.each do |g, v|
          s.teardown_group(g, false)
        end
      end
    end
  end
end
