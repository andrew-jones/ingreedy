require "parslet"

module Ingreedy
  class AmountParser < Parslet::Parser
    include CaseInsensitiveParser

    rule(:whitespace) do
      match("\s")
    end

    rule(:integer) do
      o_b_q.maybe >> match("[0-9]").repeat(1) >> c_b_q.maybe
    end

    rule(:float) do
      o_b_q.maybe >>
      integer.maybe >>
      float_delimiter >>
      integer >>
      c_b_q.maybe
    end

    rule(:float_delimiter) do
      str(",") | str(".")
    end

    rule(:fraction) do
      o_b_q.maybe >> (compound_simple_fraction | compound_vulgar_fraction) >> c_b_q.maybe
    end

    rule(:compound_simple_fraction) do
      (integer.as(:integer_amount) >> whitespace).maybe >>
        simple_fraction.as(:fraction_amount)
    end

    rule(:simple_fraction) do
     o_b_q.maybe >> integer >> match("/") >> integer >> c_b_q.maybe
    end

    rule(:compound_vulgar_fraction) do
      (integer.as(:integer_amount) >> whitespace.maybe).maybe >>
        vulgar_fraction.as(:fraction_amount)
    end

    rule(:vulgar_fraction) do
      vulgar_fractions.map { |f| str(f) }.inject(:|)
    end

    rule(:word_digit) do
      o_b_q.maybe >> (word_digits.sort {|a, b| b.size <=> a.size }.map { |d| stri(d) }.inject(:|) || any) >> c_b_q.maybe
    end

    rule(:amount) do
      fraction |
        float.as(:float_amount) |
        integer.as(:integer_amount) |
        word_digit.as(:word_integer_amount) >> whitespace
    end

    rule(:quotes) do
      match("[\"\']").repeat(1)
    end

    rule(:o_b_q) do
      quotes.maybe >> str("(").maybe >> quotes.maybe # open quate composed with brackets
    end

    rule(:c_b_q) do
      quotes.maybe >> str(")").maybe >> quotes.maybe # close quate composed with brackets
    end

    root(:amount)

    private

    def word_digits
      Ingreedy.dictionaries.current.numbers.keys
    end

    def vulgar_fractions
      Ingreedy.dictionaries.current.vulgar_fractions.keys
    end
  end
end
