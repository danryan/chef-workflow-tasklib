require 'fileutils'
require 'erb'
require 'chef-workflow/generic-support'

class KnifeSupport
  include GenericSupport

  DEFAULTS = {
    :cookbooks_path         => File.join(Dir.pwd, 'cookbooks'),
    :chef_config_path       => File.join(Dir.pwd, '.chef-workflow', 'chef'),
    :knife_config_path      => File.join(Dir.pwd, '.chef-workflow', 'chef', 'knife.rb'),
    :roles_path             => File.join(Dir.pwd, 'roles'),
    :environments_path      => File.join(Dir.pwd, 'environments')
  }

  DEFAULTS[:knife_config_template] = <<-EOF
  log_level                :info
  log_location             STDOUT
  node_name                'test-user'
  client_key               File.join('<%= KnifeSupport.singleton.chef_config_path %>', 'admin.pem')
  validation_client_name   'chef-validator'
  validation_key           File.join('<%= KnifeSupport.singleton.chef_config_path %>', 'validation.pem')
  chef_server_url          'http://<%= IPSupport.singleton.get_role_ips("chef-server").first %>:4000'
  cache_type               'BasicFile'
  cache_options( :path => File.join('<%= KnifeSupport.singleton.chef_config_path %>', 'checksums' ))
  cookbook_path            [ '<%= KnifeSupport.singleton.cookbooks_path %>' ]
  EOF

  def self.add_attribute(attr_name, default)
    KnifeSupport.configure

    DEFAULTS[attr_name] = default # a little inelegant, but it works.

    str = <<-EOF
      def #{attr_name}=(arg)
        @#{attr_name} = arg
      end

      def #{attr_name}(arg=nil)
        if arg
          @#{attr_name} = arg
        end
        
        @#{attr_name}
      end
    EOF

    KnifeSupport.singleton.instance_eval str
    KnifeSupport.singleton.send(attr_name, default)
  end
  
  DEFAULTS.each { |key, value| add_attribute(key, value) }

  def initialize(options={})
    DEFAULTS.each do |key, value|
      instance_variable_set(
        "@#{key}", 
        options.has_key?(key) ? options[key] : DEFAULTS[key]
      )
    end
  end

  def build_knife_config
    FileUtils.mkdir_p(chef_config_path)
    File.binwrite(knife_config_path, ERB.new(knife_config_template).result(binding))
  end
end
