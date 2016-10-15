module InstanceSelector
  module Providers
    # AWS Provider
    class AWS < AbstractProvider
      def initialize(options = {})
        @fog = options.delete(:fog_client)

        unless @fog
          @options = {
            region: 'us-east-1'
          }.merge(options)

          connect
        end
      end

      def instances(args = {})
        expect_count = args.delete(:expect_count)
        filters = args_to_filters(args)
        instances = on_demand_instances(filters).merge(spot_instances(filters))

        if expect_count && expect_count != instances.size
          raise UnexpectedInstanceCount, "Expected #{expect_count}, got #{instances.size}"
        end

        instances
      end

      private

      def dns_from_instance_reservation_set(reservation_set)
        reservation_set.each_with_object({}) do |i, memo|
          # Each instancesSet can have multiple instances
          # Odd, but explains why it's plural.
          i['instancesSet'].each do |instance|
            key = instance['dnsName'] || instance['ipAddress'] || instance['privateIpAddress']

            memo[key] = { name: instance['tagSet']['Name'],
                          identifier: instance['instanceId'] }
          end
        end
      end

      def on_demand_instances(filters = {})
        instances = @fog.describe_instances({ 'instance-state-name' => 'running' }.merge(filters))

        dns_from_instance_reservation_set instances.body['reservationSet']
      end

      def spot_instances(filters = {})
        requests = @fog.describe_spot_instance_requests({ 'state' => 'active' }.merge(filters))
        requests.body['spotInstanceRequestSet'].each_with_object({}) do |req, memo|
          if req['instanceId'] && !req['instanceId'].empty?
            instances = @fog.describe_instances('instance-id' => req['instanceId'])
            memo.merge! dns_from_instance_reservation_set(instances.body['reservationSet'])
          end
        end
      end

      def connect
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

      def args_to_filters(args)
        filters = {}
        filters.merge! parse_tags(args[:tags])
        filters.merge! parse_spot_request_id(args[:spot_request_id])
      end

      def parse_spot_request_id(spot_request_id)
        return {} unless spot_request_id
        { 'spot-instance-request-id' => spot_request_id }
      end

      def parse_tags(tags)
        return {} unless tags
        tags.each_with_object({}) do |tag, memo|
          memo["tag:#{tag[0]}"] = tag[1]
        end
      end
    end
  end
end
