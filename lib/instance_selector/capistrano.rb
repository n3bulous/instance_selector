require 'instance_selector'

Capistrano::Configuration.instance(:must_exist).load do
  # Yes, this is a hack
  @instance_selector_instances = {}

  def instance_selector(cap_role, provider, args={})
    role_options = args.delete(:role_options) || {}
    client = InstanceSelector::Connection.factory(provider)
    instances = client.instances(args)
    role(cap_role, *instances.keys, role_options)

    @instance_selector_instances.merge!(instances)
  end

  # Not namespaced due to collision with the above method.
  desc "List all cloud instances for a stage"
  task :instance_selector_list do
    puts
    @instance_selector_instances.sort_by {|k,v| v[:name].to_s}.each do |k, v|
      puts k + "\t" + v.values.join("\t")
    end
  end
end
