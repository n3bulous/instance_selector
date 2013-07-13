require 'instance_selector'

Capistrano::Configuration.instance(:must_exist).load do
  def instance_selector(cap_role, provider, args={})
    client = InstanceSelector::Connection.factory(provider)
    instances = client.instances(client.args_to_filters(args))
    instances.keys.each { |instance| role(cap_role, *instances.keys) }
    _cset(:instance_selector_instances) { instances }
  end

  # Not namespaced due to collision with the above method.
  desc "List all cloud instances for a stage"
  task :instance_selector_list do
    fetch(:instance_selector_instances).each do |instance|
      puts instance.join("\t")
    end
  end

end
