require "rubygems"
require "bundler/setup"
require 'dotenv'
Dotenv.load

ENV['RACK_ENV'] ||= 'development'

require_relative "aula_app"

#use Rack::Static, :urls => ["/css", "/img", "/js"], :root => "public"

run Gitforms::AulaApp.new
