module InstanceSelector
  class UnsupportedProviderException < Exception; end;

  class Connection
    def self.factory(provider, options={})
      conn = case provider
             when :aws
               Providers::AWS.new(options)
             else
               raise UnsupportedProviderException, "#{provider} is not a supported provider"
             end
    end
  end
end
