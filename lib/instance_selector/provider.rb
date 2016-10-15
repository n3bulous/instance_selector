module InstanceSelector
  class UnsupportedProviderException < RuntimeError; end

  # Provider factory for different cloud APIs
  class Provider
    def self.factory(provider, options = {})
      provider = :override if ENV['HOSTS']

      case provider
      when :aws
        Providers::AWS.new(options)
      when :override
        Providers::Override.new(options)
      else
        raise UnsupportedProviderException,
              "#{provider} is not a supported provider"
      end
    end
  end
end
