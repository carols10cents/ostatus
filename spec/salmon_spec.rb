require_relative 'helper'
require_relative '../lib/ostatus/salmon.rb'

describe OStatus::Salmon do
  describe "Salmon.from_xml" do
    it "returns nil if source is empty string" do
      OStatus::Salmon.from_xml("").must_equal(nil)
    end
  end

  describe "#to_xml" do
    it "doesn't complain about encodings when being serialized to something that can be deserialized" do
      from_author = OStatus::Author.new email: 'one@example.com', name: 'One'
      to_author   = OStatus::Author.new email: 'two@example.com', name: 'Two'
      salmon      = OStatus::Salmon.from_follow(from_author, to_author)
      keypair     = stub('keypair', private_key: stub('key', modulus: 123, exponent: 456), decrypt: 'something')

      result = salmon.to_xml(keypair)
      back_to_salmon = OStatus::Salmon.from_xml(result)
      back_to_salmon.entry.content.must_equal 'Now following Two'
      back_to_salmon.entry.author.must_equal from_author
      back_to_salmon.entry.activity_object.must_equal to_author
    end
  end
end
