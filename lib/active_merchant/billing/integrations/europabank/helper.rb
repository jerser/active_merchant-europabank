module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Europabank
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          def initialize(order, account, options = {})
            @client_secret = options.delete(:authcode)
            super
            add_field 'Description', "#{options[:account_name]}: #{order}"
            add_field 'Beneficiary', options[:account_name]
          end

          def form_fields
            extra_fields = { 'Hash' => hash }
            if @fields['Redirecturl']
              extra_fields['Redirecttype'] = 'DIRECT'
            end
            @fields.merge extra_fields
          end

          def hash
            Digest::SHA1.hexdigest([@fields['Uid'],
                                    @fields['Orderid'],
                                    @fields['Amount'],
                                    @fields['Description'],
                                    @client_secret].join).upcase
          end

          mapping :account, 'Uid'
          mapping :amount, 'Amount'
          mapping :order, 'Orderid'

          mapping :customer, :name => 'Chname',
                             :language => 'Chlanguage'

          mapping :billing_address, :country => "Chcountry"

          mapping :css, 'Css'
          mapping :template_url, 'Template'
          mapping :return_url, 'Redirecturl'
        end
      end
    end
  end
end
