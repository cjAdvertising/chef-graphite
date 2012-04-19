maintainer       "cj Advertising, LLC"
maintainer_email "gthornton@cjadvertising.com"
license          "MIT"
description      "Installs/Configures graphite"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{python gunicorn runit nginx}.each do |cb|
  depends cb
end
