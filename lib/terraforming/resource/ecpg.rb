module Terraforming
  module Resource
    class Ecpg
      include Terraforming::Util

      # TODO: Select appropriate Client class from here:
      # http://docs.aws.amazon.com/sdkforruby/api/index.html
      def self.tf(client: Aws::ElastiCache::Client.new)
        self.new(client).tf
      end

      # TODO: Select appropriate Client class from here:
      # http://docs.aws.amazon.com/sdkforruby/api/index.html
      def self.tfstate(client: Aws::ElastiCache::Client.new)
        self.new(client).tfstate
      end

      def initialize(client)
        @client = client
      end

      def tf
        apply_template(@client, "tf/ecpg")
      end

      def tfstate

      end

      def cache_parameter_groups
        @client.describe_cache_parameter_groups().map(&:cache_parameter_groups).flatten
      end

      def cache_parameters
        cache_parameter_groups.map do |group|
          parameters = {}
          resp = @client.describe_cache_parameters({ cache_parameter_group_name: group.cache_parameter_group_name, })
          parameters["parameters"] = resp.parameters
          parameters["cache_node_type_specific_parameters"] = resp.cache_node_type_specific_parameters
          parameters["cache_parameter_group"] = group.cache_parameter_group_name
          parameters["cache_parameter_group_family"] = group.cache_parameter_group_family
          parameters["description"] = group.description
          parameters
        end
      end

      def module_name_of(parameters)
        normalize_module_name(parameters["cache_parameter_group"])
      end
    end
  end
end
