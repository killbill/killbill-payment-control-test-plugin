require 'date'

module PaymentControlTest

  class PaymentControlPlugin < Killbill::Plugin::PaymentControlPluginApi

    def initialize
      super
      puts "PaymentControlTest::PaymentControlPlugin initialize..."
    end


    def prior_call(control_context, properties)

      puts "PaymentControlTest::PaymentControlPlugin prior_call : #{control_context_to_s(control_context)}"

      result = ::Killbill::Plugin::Model::PriorPaymentControlResult.new
      result.is_aborted = property_to_bool(properties, 'TEST_ABORT_PAYMENT')
      result.adjusted_amount = property_to_float(properties, 'TEST_ADJUSTED_AMOUNT')
      result.adjusted_currency = property_to_str(properties, 'TEST_ADJUSTED_CURRENCY')
      result.adjusted_payment_method_id = property_to_str(properties, 'TEST_ADJUSTED_PM_ID')
      result.adjusted_plugin_properties = nil
      result
    end

    def on_success_call(control_context, properties)
      puts "PaymentControlTest::PaymentControlPlugin on_success_call : #{control_context_to_s(control_context)}"
      ::Killbill::Plugin::Model::OnSuccessPaymentControlResult.new
    end

    def on_failure_call(control_context, properties)
      puts "PaymentControlTest::PaymentControlPlugin on_failure_call : #{control_context_to_s(control_context)}"
      result = ::Killbill::Plugin::Model::OnFailurePaymentControlResult.new
      result.next_retry_date = property_to_date(properties, 'TEST_RETRY_FAILED_PAYMENT')
      result
    end

    private

    def control_context_to_s(rc)
      "tenant = #{rc.tenant_id}, account = #{rc.account_id}, payment_external_key = #{rc.payment_external_key}, transaction_type = #{rc.transaction_type}, amount=#{rc.amount}"
    end

    def property_to_str(properties, key_name)
      res = (properties || []).select { |e| e.key == key_name }
      res[0].value if res && res.length > 0
    end

    def property_to_bool(properties, key_name)
      res = (properties || []).select { |e| e.key == key_name }
      res && res.length > 0 && res[0].value.downcase == 'true'
    end

    def property_to_float(properties, key_name)
      res = (properties || []).select { |e| e.key == key_name }
      Float(res[0].value) if res && res.length > 0
    end

    def property_to_date(properties, key_name)
      # for e.g "2012-01-20T07:30:42.000Z"
      res = (properties || []).select { |e| e.key == key_name }
      DateTime.parse(res[0].value).iso8601(3) if res && res.length > 0
    end

  end
end
