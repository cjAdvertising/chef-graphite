#
# Cookbook Name:: graphite
# Recipe:: web
#
# Copyright 2012, cj Advertising, LLC.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

package "python-cairo-dev"
package "python-django"
package "python-django-tagging"
package "python-memcache"
package "python-rrdtool"

include_recipe "gunicorn"
include_recipe "nginx"

python_pip "graphite-web" do
  version node["graphite"]["web"]["version"]
  action :install
end

directory "/opt/graphite/storage/log" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
end

directory "/opt/graphite/storage/log/webapp" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
end

directory "/opt/graphite/storage" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
end

directory "/opt/graphite/storage/whisper" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
end

cookbook_file "/opt/graphite/bin/set_admin_passwd.py" do
  mode "0755"
end

execute "graphite web sync db" do
  command "python manage.py syncdb --noinput"
  user node["graphite"]["user"]
  group node["graphite"]["group"]
  cwd "/opt/graphite/webapp/graphite"
  creates "/opt/graphite/storage/graphite.db"
  notifies :run, "execute[set admin password]"
end

execute "set admin password" do
  command "/opt/graphite/bin/set_admin_passwd.py root #{node["graphite"]["web"]["admin_password"]}"
  user node["graphite"]["user"]
  group node["graphite"]["group"]
  action :nothing
end

file "/opt/graphite/storage/graphite.db" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
  mode "644"
end

# Create nginx site config
template "#{node["nginx"]["dir"]}/sites-available/#{node["graphite"]["web"]["url"]}" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[nginx]"
end

unless node["graphite"]["web"]["auth_users"].nil?
  template "#{node["nginx"]["dir"]}/graphite_htpasswd" do
    source "htpasswd.erb"
    owner "root"
    group "root"
    mode "0644"
  end
end

# Enable nginx site
nginx_site node["graphite"]["web"]["url"]

# Run gunicorn
runit_service "graphite-web"

# Enable monit service (if conf dir exists)
template "/etc/monit/conf.d/graphite-web.conf" do
  source "monit.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    :name => "graphite-web"
  })
  only_if {::File.exists? "/etc/monit/conf.d/"}
  notifies :restart, "service[monit]"
end