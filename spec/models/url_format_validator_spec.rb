require 'spec_helper'

class UrlTest
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  attr_accessor :url
  validates :url, :url_format => true
end

describe UrlFormatValidator do
  it "validates correctly" do
    foo = UrlTest.new
    foo.url = "http://www.foo.com"
    foo.should be_valid
    foo.url = "foo.com"
    foo.should_not be_valid
    foo.url = ":"
    foo.should_not be_valid
  end
end
