require 'sanitize'

class Sanitize
  module Config
    IFRAMED = {
      :elements => %w[
        a abbr b bdo blockquote br caption cite code col colgroup dd del dfn dl
        dt em figcaption figure h1 h2 h3 h4 h5 h6 hgroup i img ins kbd li mark
        ol p pre q rp rt ruby s samp small strike strong sub sup table tbody td
        tfoot th thead time tr u ul var wbr iframe
        ],

      :attributes => {
        :all => ['dir', 'lang', 'title'],
        'a' => ['href'],
        'blockquote' => ['cite'],
        'col' => ['span', 'width'],
        'colgroup' => ['span', 'width'],
        'del' => ['cite', 'datetime'],
        'img' => ['align', 'alt', 'height', 'src', 'width'],
        'ins' => ['cite', 'datetime'],
        'ol' => ['start', 'reversed', 'type'],
        'q' => ['cite'],
        'table' => ['summary', 'width'],
        'td' => ['abbr', 'axis', 'colspan', 'rowspan', 'width'],
        'th' => ['abbr', 'axis', 'colspan', 'rowspan', 'scope', 'width'],
        'time' => ['datetime', 'pubdate'],
        'ul' => ['type'],
        'iframe' => ['src']
      },

      :protocols => {
        'a' => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
        'blockquote' => {'cite' => ['http', 'https', :relative]},
        'del' => {'cite' => ['http', 'https', :relative]},
        'img' => {'src' => ['http', 'https', :relative]},
        'ins' => {'cite' => ['http', 'https', :relative]},
        'q' => {'cite' => ['http', 'https', :relative]}
      }
    }
  end
end

module Prestashop
  module Mapper
    module Refinement
      refine String do 
        def plain
          self.clean.delete('<>;=#{}')
        end

        def clean
          Sanitize.clean self.unescape
        end

        def restricted
          Sanitize.clean(self.unescape, Sanitize::Config::RESTRICTED)
        end

        def relaxed
          Sanitize.clean(self.unescape, Sanitize::Config::RELAXED)
        end

        def iframed
          Sanitize.clean(self.unescape, Sanitize::Config::IFRAMED)
        end

        def unescape
          CGI.unescapeHTML(self)
        end

        def html
          Prestashop::Client.settings.html_enabled ? self.iframed : self.relaxed
        end

        def truncate number = 0
          self.slice(0, number)
        end
      end

      refine Hash do 
        def clean!
          reject{|k,v| v.nil? or v.empty?}
        end

        def lang_search value
          if self[:language].kind_of?(Array) 
            self[:language].find{|l| l[:val] == value and l[:attr][:id] == Prestashop::Client.settings.id_language}
          else
            self[:language][:val] == value and self[:language][:attr][:id] == Prestashop::Client.settings.id_language
          end
        end
      end
    end
  end
end