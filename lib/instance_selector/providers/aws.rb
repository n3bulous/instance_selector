module InstanceSelector
  module Providers
    class AWS
      def initialize(options={})
        @fog = options.delete(:fog_client)

        unless @fog
          @options = {
            region: 'us-east-1',
          }.merge(options)

          connect
        end
      end

      def instances(filters={})
        instances = @fog.describe_instances({"instance-state-name" => "running"}.merge(filters))
        instances.body['reservationSet'].inject({}) do |memo, i|
          instance = i['instancesSet'][0]
          memo[instance['dnsName']] = instance['tagSet']['Name']
          memo
        end
      end

      def connect
        begin
          @fog = Fog::Compute.new(provider: 'AWS', region: @options[:region])
        rescue
          @fog = Fog::Compute.new(provider:              'AWS',
                                  region:                @options[:region],
                                  aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
                                  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
        ensure
          unless @fog
            abort <<-EOS
              Could not authenticate with AWS.
              Please create a .fog file or set AWS_ACCESS_KEY_ID and AWS_ACCESS_KEY_ID
            EOS
          end
        end
      end

    end
  end
end
