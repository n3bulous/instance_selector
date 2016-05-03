__LIB_DIR__ = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift __LIB_DIR__ unless $LOAD_PATH.include?(__LIB_DIR__)

class UnexpectedInstanceCount < StandardError
end

require "instance_selector/version"
require "instance_selector/connection"
require 'instance_selector/providers/aws'
require 'fog'
