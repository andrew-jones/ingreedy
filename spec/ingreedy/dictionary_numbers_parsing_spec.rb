require "spec_helper"

describe Ingreedy do
  Ingreedy.dictionaries.current.numbers.each do |word, value|
    it "parses #{word} as #{value}" do
      expect(described_class.parse("#{word} dummy ingredient").amount).to eq(value.to_r)
    end
  end
end
