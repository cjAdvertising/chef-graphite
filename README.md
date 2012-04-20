Description
===========

Installs and configures Graphite http://graphite.wikidot.com/

Influenced by https://github.com/heavywater/chef-graphite

Requirements
============

Attributes
==========

Usage
=====

Generating an SSL cert
----------------------

    $ openssl genrsa -des3 -out graphite-ssl.key 1024
    $ openssl req -new -key graphite-ssl.key -out graphite-ssl.csr
    $ cp graphite-ssl.key graphite-ssl.key.orig
    $ openssl rsa -in graphite-ssl.key.orig -out graphite-ssl.key
    $ openssl x509 -req -days 365 -in graphite-ssl.csr -signkey graphite-ssl.key -out graphite-ssl.crt