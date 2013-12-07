require 'test_helper'

class EuropabankHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @helper = Europabank::Helper.new 'orderId-1',
                                     'mpi-uid-1',
                                     :authcode     => 'my_client_secret',
                                     :account_name => 'Partheas',
                                     :amount       => 500
  end

  def test_basic_helper_fields
    assert_field 'Uid', 'mpi-uid-1'
    assert_field 'Orderid', 'orderId-1'
    assert_field 'Beneficiary', 'Partheas'
    assert_field 'Description', 'Partheas: orderId-1'
    assert_field 'Amount', '500'
  end

  def test_customer_fields
    @helper.customer :name => 'Jeroen Serpieters', :language => 'fr'

    assert_field 'Chname', 'Jeroen Serpieters'
    assert_field 'Chlanguage', 'fr'
  end

  def test_additional_fields
    @helper.template_url = 'http://partheas.com/my_mpi_template'
    @helper.return_url = 'http://partheas.com/my_mpi_endpoint'
    @helper.css = 'http://partheas.com/my_mpi_css'

    assert_field 'Template', 'http://partheas.com/my_mpi_template'
    assert_field 'Redirecturl', 'http://partheas.com/my_mpi_endpoint'
    assert_field 'Css', 'http://partheas.com/my_mpi_css'
  end

  def test_hash_generation
    assert_equal '38060B5E2DB6ABCC87EC6C2CAC09EFEE8AE71738', @helper.hash
  end

  def test_form_fields_method
    assert_equal @helper.hash, @helper.form_fields['Hash']
    @helper.return_url = 'http://partheas.com/my_mpi_endpoint'
    assert_equal 'DIRECT', @helper.form_fields['Redirecttype']
  end

  def test_address_mapping
    @helper.billing_address :country  => 'Belgium'

    assert_field 'Chcountry', 'BE'
  end

  def test_unknown_address_mapping
    @helper.billing_address :farm => 'CA'
    # Size should be equal to basic fields
    assert_equal 5, @helper.fields.size
  end

  def test_unknown_mapping
    assert_nothing_raised do
      @helper.company_address :address => '500 Dwemthy Fox Road'
    end
  end

  def test_setting_invalid_address_field
    fields = @helper.fields.dup
    @helper.billing_address :street => 'My Street'
    assert_equal fields, @helper.fields
  end
end
