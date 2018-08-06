module Terraforming
  module Resource
    class DynamoDB
      include Terraforming::Util

      # TODO: Select appropriate Client class from here:
      # http://docs.aws.amazon.com/sdkforruby/api/index.html
      def self.tf(client: Aws::DynamoDB::Client.new)
        self.new(client).tf
      end

      # TODO: Select appropriate Client class from here:
      # http://docs.aws.amazon.com/sdkforruby/api/index.html
      def self.tfstate(client: Aws::DynamoDB::Client.new)
        self.new(client).tfstate
      end

      def initialize(client)
        @client = client
      end

      def tf
        apply_template(@client, "tf/dynamodb")
      end

      def tfstate

      end

      def dynamodb_tables
        @client.list_tables().map(&:table_names).flatten
      end

      def tables
        dynamodb_tables.map do |table|
          @client.describe_table({table_name: table})
        end
      end

      def module_name_of(table)
        normalize_module_name(table.table.table_name)
      end

    end
  end
end
