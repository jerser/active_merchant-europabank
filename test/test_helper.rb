#!/usr/bin/env ruby
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'test/unit'
require 'active_merchant'

require_relative '../lib/active_merchant/billing/integrations/europabank'
require_relative '../lib/active_merchant/billing/integrations/europabank/helper'
require_relative '../lib/active_merchant/billing/integrations/europabank/notification'
require_relative '../lib/active_merchant/billing/integrations/europabank/return'

ActiveMerchant::Billing::Base.mode = :test

module ActiveMerchant
  module Assertions
    AssertionClass = RUBY_VERSION > '1.9' ? MiniTest::Assertion : Test::Unit::AssertionFailedError

    def assert_field(field, value)
      clean_backtrace do
        assert_equal value, @helper.fields[field]
      end
    end

    private
    def clean_backtrace(&block)
      yield
    rescue AssertionClass => e
      path = File.expand_path(__FILE__)
      raise AssertionClass, e.message, e.backtrace.reject { |line| File.expand_path(line) =~ /#{path}/ }
    end
  end
end

Test::Unit::TestCase.class_eval do
  include ActiveMerchant::Billing
  include ActiveMerchant::Assertions
  include ActiveMerchant::Utils
end
