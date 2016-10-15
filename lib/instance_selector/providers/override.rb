module InstanceSelector
  module Providers
    # Uses the HOSTS environment variable instead of a cloud provider
    class Override < AbstractProvider
      def initialize(_options = {})
        @hosts = ENV['HOSTS']
      end

      def instances(_args = {})
        results = {}
        ENV['HOSTS'].split(',').each do |host|
          results[host] = { name: host, identifier: 'N/A' }
        end

        results
      end
    end
  end
end
