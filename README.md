# Loose Change is a Ruby ORM for CouchDB

* where 'ORM' is as accurate as ['Holy Roman
Empire'](http://en.wikipedia.org/wiki/Holy_Roman_Empire#Analysis)

## Goals and Principles

* Take advantage of
  [ActiveModel](http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/)
* Make common tasks easy; get out of your way if you need the metal
* Make working with [GeoCouch](http://github.com/vmx/couchdb) seamless

## Warnings

* This is pretty alpha at this point.
* Only tested on Ruby 1.9.2.  I'm not intentionally breaking 1.8.x, but neither do I guarantee anything.
* The stuff about GeoCouch above was a goal I didn't get to yet.

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
