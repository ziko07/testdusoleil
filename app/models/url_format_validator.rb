
# use with 
# validates :myattr, :url_validator => true

class UrlFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    uri = URI.parse(value)
    unless uri.host
      object.errors[attribute] << "needs a hostname or is missing 'http://'"
    end
  rescue URI::InvalidURIError
    object.errors[attribute] << "is not a valid URI"
  end
end

