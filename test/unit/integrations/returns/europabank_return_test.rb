require 'test_helper'

class EuropabankNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_successful_return
    returned = Europabank::Return.new successful_return,
                                      {:authcode => 'my_client_secret'}
    assert returned.success?
    assert_equal false, returned.cancelled?
  end

  def test_failed_return
    returned = Europabank::Return.new failed_return,
                                      {:authcode => 'my_client_secret'}
    assert_equal false, returned.success?
    assert returned.cancelled?
  end

  def test_invalid_hash_return
    returned = Europabank::Return.new invalid_hash,
                                      {:authcode => 'my_client_secret'}
    assert_equal false, returned.success?
    assert returned.cancelled?
  end

  def test_message
    authorized = Europabank::Return.new successful_return,
                                      {:authcode => 'my_client_secret'}
    assert_equal 'Authorized', authorized.message

    cancelled = Europabank::Return.new failed_return,
                                      {:authcode => 'my_client_secret'}
    assert_equal 'Cancelled', cancelled.message

    declined = Europabank::Return.new failed_return.sub('CA', 'DE'),
                                      {:authcode => 'my_client_secret'}
    assert_equal 'Declined', declined.message

    timed_out = Europabank::Return.new failed_return.sub('CA', 'TI'),
                                      {:authcode => 'my_client_secret'}
    assert_equal 'Timed Out', timed_out.message

    exception = Europabank::Return.new failed_return.sub('CA', 'EX'),
                                      {:authcode => 'my_client_secret'}
    assert_equal 'Technical Problem', exception.message
  end

  private
  def successful_return
    'Uid=mpi-uid-1&Orderid=orderId-1&Brand=M&Id=mpi-uniqid-1&Status=AU'\
      '&Hash=B645AEB41B7A35DC2A4D212024A18148F346556C'
  end

  def failed_return
    'Uid=mpi-uid-1&Orderid=orderId-1&Brand=M&Id=mpi-uniqid-1&Status=CA'\
      '&Hash=38060B5E2DB6ABCC87EC6C2CAC09EFEE8AE71738'
  end

  def invalid_hash
    'Uid=mpi-uid-1&Orderid=orderId-1&Brand=M&Id=mpi-uniqid-1&Status=AU'\
      '&Hash=38060b5e2db6abcc87ec6c2cac09efee8ae71738'
  end
end
