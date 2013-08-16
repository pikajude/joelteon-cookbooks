name             'joelteon'
maintainer       'Joel Taylor'
maintainer_email 'me@joelt.io'
license          'MIT'
description      'Setup das dev environment'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports "centos"

depends "build-essential"
depends "yum"
depends "postgres"
depends "imagemagick"
depends "ghc"

recipe "joelteon", "Sets up the full dev environment"
recipe "joelteon::lexie", "Sets up env for lexie"
recipe "joelteon::site", "Sets up env for my yesod website"
