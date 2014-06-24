require 'sinatra/base'
# require 'multi_json'
require 'pry'
require 'virtus'
require 'active_model'
require 'json'

require_relative 'lib/stupid_storeman'
require_relative 'lib/aula'


class Input
  include Virtus.model
  # include ActiveModel::Validations

  # class ValidationError < StandardError; end

  # def validate!
  #   raise Input::ValidationError.new, errors unless valid?
  # end

  def params
    to_hash
  end
end