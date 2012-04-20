#
# Cookbook Name:: graphite
# Attributes:: default
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

default[:graphite][:user] = "www-data"
default[:graphite][:group] = "www-data"

default[:graphite][:whisper][:version] = "0.9.9"

default[:graphite][:web][:version] = "0.9.9"
default[:graphite][:web][:port] = "80"
default[:graphite][:web][:url] = "graphite"
default[:graphite][:web][:socket] = "/opt/graphite/storage/gunicorn.sock"
default[:graphite][:web][:admin_password] = "changeme"
default[:graphite][:web][:auth_users] = nil

default[:graphite][:carbon][:version] = "0.9.9"
default[:graphite][:carbon][:line_receiver_interface] = "127.0.0.1"
default[:graphite][:carbon][:pickle_receiver_interface] = "127.0.0.1"
default[:graphite][:carbon][:cache_query_interface] = "127.0.0.1"
