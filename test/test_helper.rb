ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/pride'
require 'active_support/test_case'
require 'mocha/setup'
require_relative '../config/environment'
ENV['DRIVER'] = NullDriver.to_s
