require File.dirname(__FILE__) + '/europabank/helper.rb'
require File.dirname(__FILE__) + '/europabank/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Europabank

        mattr_accessor :test_url
        self.test_url = 'https://www.ebonline.be/test/mpi/authenticate'

        mattr_accessor :production_url
        self.production_url = 'https://www.ebonline.be/mpi/authenticate'

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
          when :production
            self.production_url
          when :test
            self.test_url
          else
            raise StandardError,
                  "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.notification(post)
          Notification.new(post)
        end
      end
    end
  end
end
