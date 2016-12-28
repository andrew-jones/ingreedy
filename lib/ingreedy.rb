path = File.expand_path(File.join(File.dirname(__FILE__), "ingreedy"))

require File.join(path, "case_insensitive_parser")
require File.join(path, "ingreedy_parser")
require File.join(path, "dictionary_collection")

module Ingreedy
  class EmptyAmount < Parslet::ParseFailed; end
  class IncorrectIngredient < Parslet::ParseFailed; end
  ParseFailed = Class.new(StandardError)

  class << self
    attr_accessor :locale, :preserve_amounts, :after_error
  end

  def self.parse(query)
    parser = Parser.new(query)
    parser.parse
  end

  def self.dictionaries
    @dictionaries ||= DictionaryCollection.new
  end
end
