require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'mocha/setup'
require 'factory_girl'

require 'prestashop'

WebMock.disable_net_connect!(allow: "codeclimate.com")

# Load factories
include FactoryGirl::Syntax::Methods
Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each { |f| require f }

LONG_STRING = %(Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum gravida tortor quam, in vulputate mi porta vitae. Curabitur sem justo, egestas ac interdum egestas, facilisis sed nulla. Donec sit amet odio vel orci scelerisque sagittis. Nulla facilisi. Ut id augue sem. Ut posuere dolor ut sapien tincidunt pellentesque. Maecenas eros est, commodo quis suscipit ut, condimentum vel risus.

Donec at sem erat. Sed vestibulum venenatis sem, laoreet varius enim dictum et. Phasellus nisi arcu, pulvinar et arcu at, congue volutpat felis. Nunc ut nunc ultrices, egestas diam quis, feugiat ipsum. Sed orci mi, rutrum vel sapien quis, fringilla congue nulla. Aenean eu consectetur erat. Nullam fringilla nunc ligula, id fermentum mauris elementum a. Sed elementum sit amet nisl eu viverra. Mauris iaculis erat neque, at imperdiet metus molestie ut. Phasellus ac dictum felis, ac iaculis massa. Morbi non sem est. Proin iaculis mauris erat, sollicitudin dapibus quam cursus et. Nunc molestie euismod nulla in tincidunt.

Etiam lobortis sem eu lectus sollicitudin tristique. Maecenas et dui vel nisi semper blandit non id velit. Suspendisse cursus eget metus sed elementum. Proin eu porta turpis. Aenean sollicitudin mauris sit amet mauris rutrum, eget lacinia tellus lacinia. Nullam dictum metus erat. Sed ut mauris imperdiet, scelerisque massa sed, convallis neque. Nam tortor arcu, ullamcorper eget libero eu, elementum rhoncus quam. Suspendisse elementum venenatis purus, sed interdum sapien tincidunt vitae.

Nunc eget tincidunt turpis. Nullam sed luctus leo. Nulla semper scelerisque tempus. Proin nec enim urna. Nulla facilisi. Etiam vel dolor in metus accumsan lacinia. Vestibulum venenatis nisl a elit sagittis, vitae rhoncus diam aliquam. Etiam iaculis purus augue, at faucibus justo sagittis in. Sed nec semper dolor. Aenean blandit lorem at tincidunt tincidunt. Duis facilisis tortor massa, sit amet facilisis ligula placerat sed.

Mauris eu mi in nibh consequat sodales non sit amet arcu. Vivamus sed libero libero. Suspendisse nec ante volutpat, iaculis ipsum a, vulputate neque. Phasellus eu sodales nunc. Interdum et malesuada fames ac ante ipsum primis in faucibus. Donec commodo diam at libero viverra, sit amet sodales nunc condimentum. Suspendisse hendrerit blandit dolor tincidunt luctus. Fusce faucibus porta enim in placerat. Praesent bibendum posuere dignissim. Aliquam pharetra, magna sit amet vehicula molestie, nisl neque eleifend tellus, vel rhoncus purus purus quis sem. Aliquam pretium mauris tincidunt, commodo dui quis, pulvinar leo. Maecenas id metus facilisis, euismod mauris id, hendrerit eros. Aenean vitae nulla elementum, vehicula diam eu, condimentum neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. )
