require 'open-uri'
require 'sanitize'

String.class_eval do 
  def valid_url?
    uri = URI.parse self
    uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)
  rescue
    false
  end

  def plain
    self.restricted.delete('<>;=#{}')
  end

  def restricted
    Sanitize.clean self.unescape
  end

  def unescape
    CGI.unescapeHTML(self)
  end

  def html
    Prestashop::Client.settings.html_enabled ? self.unescape : self.restricted
  end
end