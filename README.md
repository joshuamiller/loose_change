# Loose Change is a Ruby ORM for CouchDB

* where 'Object-Relational Mapper' is as accurate as ['Holy Roman
Empire'](http://en.wikipedia.org/wiki/Holy_Roman_Empire#Analysis)

## Goals and Principles

* Take advantage of
  [ActiveModel](http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/)
* Make common tasks easy; get out of your way if you need the metal
* Make working with [GeoCouch](http://github.com/vmx/couchdb) seamless

## GeoCouch Support

Documents with spatial properties are now supported if you are running
the latest version of [GeoCouch from
git](http://github.com/vmx/couchdb).  Only Point and MultiPoint
geometries are currently supported and tested.

## Warnings

* Only tested on Ruby 1.9.2.  I'm not intentionally breaking 1.8.x, but neither do I guarantee anything.

## Todo

* Add Rake tasks to push complicated views from a JS directory

## Help

* Accepted. Fork at
  [Github](http://github.com/joshuamiller/loose_change)

## Shoulders of Giants

Inspiration and help from:

* [RestClient](http://github.com/archiloque/rest-client), for the
  basic HTTP plumbing.
* [CouchRest](http://github.com/couchrest/couchrest), for the idea and
  basic structure of using RestClient to talk to CouchDB.
* [CouchRest-Rails](http://github.com/hpoydar/couchrest-rails), for
  implementation ideas for interacting with Rails.
* [will_paginate](http://github.com/mislave/will_paginate), for making
  pagination a dead-simple addition.

## License

* MIT.  See LICENSE for more details.
