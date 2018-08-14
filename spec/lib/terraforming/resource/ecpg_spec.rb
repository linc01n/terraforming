require "spec_helper"

module Terraforming
  module Resource
    describe Ecpg do
      let(:client) do
        # TODO: Select appropriate Client class from here:
        # http://docs.aws.amazon.com/sdkforruby/api/index.html
        Aws::SomeResource::Client.new(stub_responses: true)
      end

      describe ".tf" do
        xit "should generate tf" do
          expect(described_class.tf(client: client)).to eq <<-EOS
resource "aws_ecpg" "resource_name" {

}

        EOS
        end
      end

      describe ".tfstate" do
        xit "should generate tfstate" do
          expect(described_class.tfstate(client: client)).to eq({
            "aws_ecpg.resource_name" => {
              "type" => "aws_ecpg",
              "primary" => {
                "id" => "",
                "attributes" => {
                }
              }
            }
          })
        end
      end
    end
  end
end
