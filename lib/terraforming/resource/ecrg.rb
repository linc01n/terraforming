module Terraforming
  module Resource
    class Ecrg
      include Terraforming::Util

      def self.tf(client: Aws::ElastiCache::Client.new)
        self.new(client).tf
      end

      def self.tfstate(client: Aws::ElastiCache::Client.new)
        self.new(client).tfstate
      end

      def initialize(client)
        @client = client
      end

      def tf
        apply_template(@client, "tf/ecrg")
      end

      def tfstate
        replication_groups.inject({}) do |resources, replication_group|
          attributes = {
            "node_groups.#" => replication_group.node_groups.length.to_s,
            "replication_group_id" => replication_group.replication_group_id,
            "replication_group_description" => replication_group.description,
            "node_type" => replication_group.cache_node_type,
            "number_cache_clusters" => replication_group.member_clusters.length,
            "at_rest_encryption_enabled" => replication_group.at_rest_encryption_enabled,
          }

          attributes["port"] = if replication_group.configuration_endpoint
                                 replication_group.configuration_endpoint.port.to_s
                               end

          attributes["automatic_failover_enabled"] = if replication_group.automatic_failover == "enabled"
                                                        "true"
                                                     else "false"
                                                     end

          resources["aws_elasticache_replication_group.#{module_name_of(replication_group)}"] = {
            "type" => "aws_elasticache_replication_group",
            "primary" => {
              "id" => replication_group.replication_group_id,
              "attributes" => attributes
            }
          }

          resources
        end
      end

      private

      def replication_groups
        @client.describe_replication_groups().map(&:replication_groups).flatten
      end

      def module_name_of(replication_group)
        normalize_module_name(replication_group.replication_group_id)
      end
    end
  end
end
