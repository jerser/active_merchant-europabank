require 'test_helper'

class EuropabankModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_notification_method
    assert_instance_of Europabank::Notification,
                       Europabank.notification({'Id'      => '',
                                                'Orderid' => '',
                                                'Hash'    => ''})
  end

  def test_service_url
    ActiveMerchant::Billing::Base.integration_mode = :test
    assert_equal 'https://www.ebonline.be/test/mpi/authenticate',
                  Europabank.service_url

    ActiveMerchant::Billing::Base.integration_mode = :production
    assert_equal 'https://www.ebonline.be/mpi/authenticate',
                  Europabank.service_url
  end
end
