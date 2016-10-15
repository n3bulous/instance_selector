$LOAD_PATH.unshift __LIB_DIR__ unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

class UnexpectedInstanceCount < StandardError
end

require 'instance_selector/version'
require 'instance_selector/provider'
require 'instance_selector/providers/provider'
require 'instance_selector/providers/aws'
require 'instance_selector/providers/override'
require 'fog/aws'
