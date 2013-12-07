ActiveMerchant Billing Integration for Europabank MPI
==========================

Integration for [Europabank MPI](https://www.europabank.be/ecommerce-professioneel)

Installation
------------

Add active_merchant-europabank to your Gemfile:

```ruby
gem 'active_merchant-europabank', github: 'jerser/active_merchant-europabank'
```

Usage
---------
---------

The easiest way to use it is by using ActiveMerchants payment_service_for
view helper. Currently this will only work when using action_view from the Rails
master branch, which includes the necessary [enforce_utf8](https://github.com/rails/rails/commit/06388b07791a24e9d3351a74bfdf23809bb1e69b) flag in the form_tag helper.
Without this flag, the Europabank MPI will get an unknown field and redirect you
to their homepage instead of telling you what is wrong. It is important that you
do not send any other form field then the ones supported by Europabank MPI, also
keep in mind that the name of your forms submit button has to start with lower
case submit (or just use submit).

Example usage:

```ruby
<% payment_service_for @order.number,
                       @payment_method.preferred(:uid),

                       account_name: @payment_method.preferred(:beneficiary),
                       authcode: @payment_method.preferred(:client_secret),

                       html: {enforce_utf8: false, authenticity_token: false},

                       service: :europabank do |service|
%>
<% service.amount (@order.total * 100).to_i %>
<% service.return_url europabank_return_order_checkout_url %>
<% service.customer name: "#{@order.bill_address.firstname} "\
                          "#{@order.bill_address.lastname}",
                    language: I18n.locale %>
<% service.billing_address country: @order.bill_address.country.name %>
<% service.css = @payment_method.preferred(:css_url) %>
<% service.template = @payment_method.preferred(:template_url) %>
<%= submit_tag Spree.t('pay_with_europabank'), name: 'submit' %>
<% end %>
```

Without the payment_service_for helper you will have to manually construct the
form. Take a look [here](https://github.com/jerser/spree_europabank/commit/be87f2ee045b3190dd44dff7478675c62befa384#diff-645e8bb9292d7fbfa876582d1d29f773R1) and [here](https://github.com/jerser/spree_europabank/commit/be87f2ee045b3190dd44dff7478675c62befa384#diff-eadf1ab3e046e32d8d2152437469939fR13) for details.

Spree integration
-------

There is also a [Spree](http://spreecommerce.com) extension for Europabank MPI,
you can find it at <https://github.com/jerser/spree_europabank>

Copyright (c) 2013 Jeroen Serpieters, released under the MIT License
