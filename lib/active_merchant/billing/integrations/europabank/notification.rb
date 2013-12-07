require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Europabank
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def complete?
            status == 'AU'
          end

          def order_id
            params['Orderid']
          end

          def card_type
            return :master  if params['Brand'] == 'M'
            return :visa    if params['Brand'] == 'V'
            return :maestro if params['Brand'] == 'A'
          end

          def security_key
            params['Hash'].upcase if params['Hash']
          end

          def status
            params['Status']
          end

          def acknowledge(authcode = nil)
            returned_hash = [params['Id'], params['Orderid'], authcode].join
            Digest::SHA1.hexdigest(returned_hash).upcase == security_key
          end
        end
      end
    end
  end
end
