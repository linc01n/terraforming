module Terraforming
  module Resource
    class AutoScalingGroupPolicy
      include Terraforming::Util

      # TODO: Select appropriate Client class from here:
      # http://docs.aws.amazon.com/sdkforruby/api/index.html
      def self.tf(client: Aws::AutoScaling::Client.new)
        self.new(client).tf
      end

      # TODO: Select appropriate Client class from here:
      # http://docs.aws.amazon.com/sdkforruby/api/index.html
      def self.tfstate(client: Aws::AutoScaling::Client.new)
        self.new(client).tfstate
      end

      def initialize(client)
        @client = client
      end

      def tf
        apply_template(@client, "tf/AutoScalingGroupPolicy")
      end

      def tfstate

      end

      def auto_scaling_groups
        @client.describe_auto_scaling_groups().map(&:auto_scaling_groups).flatten
      end

      def auto_scaling_group_policies(group)
        begin
          policies = @client.describe_policies(auto_scaling_group_name: group.auto_scaling_group_name).map(&:scaling_policies).flatten
          policies
        rescue => exception
          sleep(0.5)
          auto_scaling_group_policies(group)
        end
      end

      def module_name_of(policy)
        normalize_module_name("#{policy.auto_scaling_group_name}-#{policy.policy_name}")
      end
    end
  end
end
