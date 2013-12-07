require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Europabank
        class Return < ActiveMerchant::Billing::Integrations::Return
          def initialize(query_string, options = {})
            @options = options
            @notification = Europabank::Notification.new query_string, @options
          end

          def success?
            @notification && @notification.acknowledge(@options[:authcode]) &&
              @notification.complete?
          end

          def cancelled?
            @notification.nil? || !@notification.acknowledge(@options[:authcode]) ||
              !@notification.complete?
          end

          def message
            if @notification
              case @notification.status
              when 'AU'
                'Authorized'
              when 'DE'
                'Declined'
              when 'CA'
                'Cancelled'
              when 'TI'
                'Timed Out'
              else
                'Technical Problem'
              end
            end
          end
        end
      end
    end
  end
end
