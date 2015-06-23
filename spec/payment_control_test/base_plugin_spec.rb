require 'spec_helper'
require 'logger'

require 'payment_control_test'

describe PaymentControlTest::PaymentControlPlugin do
  before(:each) do

    kb_apis = Killbill::Plugin::KillbillApi.new("killbill-payment-control-test", {})
    @plugin = PaymentControlTest::PaymentControlPlugin.new
    @plugin.logger = Logger.new(STDOUT)
    @plugin.kb_apis = kb_apis

    @routing_context = ::Killbill::Plugin::Model::PaymentRoutingContext.new
    @routing_context.tenant_id = '12345'
    @routing_context.account_id = '54321'
    @routing_context.payment_external_key = 'foo'
    @routing_context.transaction_type = 'AUTH'
    @routing_context.amount = 12.7
  end

  it "should start and stop correctly" do
    @plugin.start_plugin
    @plugin.stop_plugin
  end


  it "should abort payment " do
    properties = []
    add_plugin_property('TEST_ABORT_PAYMENT',"true", properties)

    output = @plugin.prior_call(@routing_context, properties)
    output.is_aborted.should be_true
  end


  private

  def add_plugin_property(key, value, props)
    p = Killbill::Plugin::Model::PluginProperty.new
    p.key = key
    p.value = value
    p.is_updatable = false
    props << p
  end
end
