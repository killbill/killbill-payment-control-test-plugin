require 'spec_helper'
require 'logger'

require 'payment_control_test'

describe PaymentControlTest::PaymentControlPlugin do
  before(:each) do

    kb_apis = Killbill::Plugin::KillbillApi.new("killbill-payment-control-test", {})
    @plugin = PaymentTest::PaymentPlugin.new
    @plugin.logger = Logger.new(STDOUT)
    @plugin.kb_apis = kb_apis

  end

end
