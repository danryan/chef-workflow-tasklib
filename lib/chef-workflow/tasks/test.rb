require 'rake/testtask'
require 'chef-workflow/support/scheduler'
require 'chef-workflow/support/knife'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir["test/**/test_*.rb"]
  t.verbose = true
end

namespace :test do
  desc "Test recipes in the test_recipes configuration."

  task :recipes => [ "recipes:cleanup" ] do
    Chef::Config.from_file(KnifeSupport.singleton.knife_config_path)

    s = Scheduler.new(true)
    s.run

    groups =
    KnifeSupport.singleton.test_recipes.map do |recipe|
      group_name = "recipe-#{recipe.gsub(/::/, '-')}"

      kp               = VM::KnifeProvisioner.new
      kp.username      = KnifeSupport.singleton.ssh_user
      kp.password      = KnifeSupport.singleton.ssh_password
      kp.use_sudo      = KnifeSupport.singleton.use_sudo
      kp.ssh_key       = KnifeSupport.singleton.ssh_identity_file
      kp.environment   = KnifeSupport.singleton.test_environment
      kp.template_file = KnifeSupport.singleton.template_file
      kp.run_list      = [ "recipe[#{recipe}]", "recipe[minitest-handler]" ]
      kp.solr_check    = false

      s.schedule_provision(
        group_name,
        [
          GeneralSupport.singleton.machine_provisioner.new(group_name, 1),
          kp
        ]
      )

      group_name
    end

    s.wait_for(*groups)

    groups.each do |group_name|
      s.teardown_group(group_name)
    end

    s.write_state
  end

  namespace :recipes do
    desc "Cleanup any stale instances created running recipe tests."
    task :cleanup do
      Chef::Config.from_file(KnifeSupport.singleton.knife_config_path)
      s = Scheduler.new(false)
      s.run

      s.vm_groups.select do |g, v|
        g.start_with?("recipe-")
      end.each do |g, v|
        s.teardown_group(g, false)
      end

      s.write_state
    end
  end
end
