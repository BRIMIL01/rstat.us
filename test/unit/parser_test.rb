require 'require_relative' if RUBY_VERSION[0,3] == '1.8'
require_relative '../test_helper'

class ParserTest < MiniTest::Unit::TestCase

  include TestHelper

  def test_parse_string
    parser = UpdateParser.new("This is a test update")
    assert_equal true, parser.parse
    assert_equal "This is a test update", parser.processed
  end

  def test_username
    parser = UpdateParser.new("This is a test update for @steve")
    parser.parse
    assert_equal "This is a test update for @steve", parser.processed
  end

  def test_known_username
    Factory(:user, :username => "steve")
    parser = UpdateParser.new("This is a test update for @steve")
    parser.parse
    assert_equal "This is a test update for <a href='/users/steve'>@steve</a>", parser.processed
  end

  def test_tag_extract
    parser = UpdateParser.new("This is a test update for #steve and #frank and @bob")
    parser.parse
    assert_equal "This is a test update for <a href='/hashtags/steve'>#steve</a> and <a href='/hashtags/frank'>#frank</a> and @bob", parser.processed
    assert_equal ["steve", "frank"], parser.tags
  end
end
