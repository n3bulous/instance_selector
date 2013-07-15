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
          key = instance['dnsName'].empty? ? instance['ipAddress'] : instance['dnsName']
          memo[key] = instance['tagSet']['Name']
          memo
        end
      end

      def connect
        begin
          @fog = Fog::Compute.new(provider:              'AWS',
                                  region:                @options[:region],
                                  aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
                                  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
        rescue
          @fog = Fog::Compute.new(provider: 'AWS', region: @options[:region])
        ensure
          unless @fog
            abort <<-EOS
              Could not authenticate with AWS.
              Please create a .fog file or set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
            EOS
          end
        end
      end

      def args_to_filters(args)
        filters = {}
        filters.merge! parse_tags(args[:tags])
      end

      def parse_tags(tags)
        tags.inject({}) do |memo, tag|
          memo["tag:#{tag[0]}"] = tag[1]
          memo
        end
      end

    end
  end
end
