require 'test_helper'

class EuropabankNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @europabank = Europabank::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @europabank.complete?
    assert_equal 'orderId-1', @europabank.order_id
    assert_equal :master, @europabank.card_type
    assert_equal 'B645AEB41B7A35DC2A4D212024A18148F346556C', @europabank.security_key
    assert_equal 'AU', @europabank.status
  end

  def test_card_type
    mastercard = Europabank::Notification.new 'Brand=M'
    assert_equal :master, mastercard.card_type

    visa = Europabank::Notification.new 'Brand=V'
    assert_equal :visa, visa.card_type

    maestro = Europabank::Notification.new 'Brand=A'
    assert_equal :maestro, maestro.card_type
  end

  def test_complete
    complete = Europabank::Notification.new 'Status=AU'
    assert complete.complete?

    not_completed = Europabank::Notification.new 'Status=DE'
    assert_equal false, not_completed.complete?
  end

  def test_acknowledgement
    assert @europabank.acknowledge('my_client_secret')
  end

  def test_faulty_acknowledgement
    europabank = Europabank::Notification.new 'Uid=mpi-uid-1&Orderid=orderId-1'\
                                              '&Brand=M&Id=mpi-uniqid-1&Status=AU'\
                                              '&Hash=38060B5E2DB6ABCC87EC6C2CAC09EFEE8AE71738'
    assert_equal false, europabank.acknowledge('my_client_secret')
  end

  def test_respond_to_acknowledge
    assert @europabank.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    'Uid=mpi-uid-1&Orderid=orderId-1&Brand=M&Id=mpi-uniqid-1&Status=AU'\
      '&Hash=B645AEB41B7A35DC2A4D212024A18148F346556C'
  end
end
