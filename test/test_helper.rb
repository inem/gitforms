ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require 'minitest/autorun'
require 'fakefs/safe'

require_relative '../gitforms'
