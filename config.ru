ENV['RACK_ENV'] ||= 'development'
require "rubygems"
require "bundler/setup"
require 'dotenv'
Dotenv.load

$LOAD_PATH << File.dirname(__FILE__) + '/lib'
#require File.expand_path(File.join(File.dirname(__FILE__), 'aula_app'))
#require File.expand_path(File.join(File.dirname(__FILE__), 'authentication_app'))

require_relative "aula_app.rb"
require_relative "authentication_app.rb"

#use Rack::Static, :urls => ["/css", "/img", "/js"], :root => "public"


#run Rack::URLMap.new \
#  "/aula.io" => Gitforms::Aula.new,
#  "/"    => Gitforms::Authentication.new

run Gitforms::Aula.new

# vim:ft=ruby