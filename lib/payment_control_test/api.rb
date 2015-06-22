module PaymentControlTest

  class PaymentControlPlugin < Killbill::Plugin::PaymentRoutingPluginApi

    def initialize
    end

    def prior_call(routing_context, properties)
      raise OperationUnsupportedByGatewayError
    end

    def on_success_call(routing_context, properties)
      raise OperationUnsupportedByGatewayError
    end

    def on_failure_call(routing_context, properties)
      raise OperationUnsupportedByGatewayError
    end

  end
end
