#
# Cookbook Name:: graphite
# Recipe:: carbon
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

package "python-twisted"
package "python-simplejson"

python_pip "carbon" do
  version node["graphite"]["carbon"]["version"]
  action :install
end

template "/opt/graphite/conf/carbon.conf" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
  variables( :line_receiver_interface => node[:graphite][:carbon][:line_receiver_interface],
             :pickle_receiver_interface => node[:graphite][:carbon][:pickle_receiver_interface],
             :cache_query_interface => node[:graphite][:carbon][:cache_query_interface] )
  notifies :restart, "service[carbon-cache]"
end

template "/opt/graphite/conf/storage-schemas.conf" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
end

execute "carbon: change graphite storage permissions to www-data" do
  command "chown -R #{node["graphite"]["user"]}:#{node["graphite"]["group"]} /opt/graphite/storage"
  not_if do
    f = ::File.stat("/opt/graphite/storage")
    u = ::Etc.getpwnam(node["graphite"]["user"])
    f.uid == u.uid and f.gid == u.gid
  end
end

directory "/opt/graphite/lib/twisted/plugins/" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
end

runit_service "carbon-cache" do
  finish_script true
end

# Enable monit service (if conf dir exists)
template "/etc/monit/conf.d/carbon-cache.conf" do
  source "monit.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    :name => "carbon-cache"
  })
  only_if {::File.exists? "/etc/monit/conf.d/"}
  notifies :restart, "service[monit]"
end