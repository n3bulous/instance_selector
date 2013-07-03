require 'instance_selector'

Capistrano::Configuration.instance(:must_exist).load do
  def instance_selector(cap_role, provider, args={})
    client = InstanceSelector::Connection.factory(:aws)
    instances = client.instances(client.args_to_filters(args))
    instances.keys.each { |instance| role(cap_role, *instances.keys) }
  end
end
