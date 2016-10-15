module InstanceSelector
  module Providers
    # Abstract class for providers
    class AbstractProvider
      # Returns a hash of instance network resources and the associated attributes.
      # e.g. (not realistic data):
      #   {
      #     '127.0.0.1' => { name: 'localhost', identifier: 'N/A' }
      #     '10.10.1.1' => { name: 'aws name tag', identifier: 'i-abcdef01' }
      #   }
      def instances(_args = {})
        raise NotImplementedError, 'A provider must implement #instances'
      end
    end
  end
end
