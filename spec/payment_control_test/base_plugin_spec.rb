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
    output.adjusted_amount.should be_nil
    output.adjusted_currency.should be_nil
    output.adjusted_payment_method_id.should be_nil
    output.adjusted_plugin_properties.should be_nil
  end


  it "should overwite amount and currency " do
    properties = []
    add_plugin_property('TEST_ADJUSTED_AMOUNT',"12.78", properties)
    add_plugin_property('TEST_ADJUSTED_CURRENCY',"EUR", properties)

    output = @plugin.prior_call(@routing_context, properties)
    output.is_aborted.should be_false
    output.adjusted_amount.should == 12.78
    output.adjusted_currency.should == 'EUR'
    output.adjusted_payment_method_id.should be_nil
    output.adjusted_plugin_properties.should be_nil
  end

  it "should test on succcess " do
    properties = []
    add_plugin_property('TEST_ABORT_PAYMENT',"true", properties)

    @plugin.on_success_call(@routing_context, properties)
  end

  it "should test on failure " do
    properties = []
    add_plugin_property('TEST_RETRY_FAILED_PAYMENT',"2012-01-20T07:30:42.000Z", properties)

    output = @plugin.on_failure_call(@routing_context, properties)

    puts "output = #{output.inspect}"

    output.next_retry_date.should == DateTime.parse("2012-01-20T07:30:42.000+00:00").iso8601(3)
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
