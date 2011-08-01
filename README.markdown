API Sandbox jQuery Plugin
=========================

API Sandbox is a jQuery plugin written in CoffeeScript that allows web apps to easily implement sandbox environments for an API explorer. The design of the sandbox is configurable by editing the api_sandbox.sass file included in this repository.

Usage
-----

API Sandbox requires jQuery. The plugin takes two arguments, one for an HTTP method, and another for the API path. The plugin parses the URL and creates editable fields on the page for each URL parameter so the API path can be tested. For example:

    $("#user").apiSandbox("get","/api/v1/users?user_id=")

This would place an API sandbox with one field for user_id in a div element with an id of user on the page.

API Sandbox recognizes URL parameters in three forms: `:symbols`, `?first_param=`, and `&subsequent_params=`. Here's an example with multiple types of params in one URL string:

    $("#user").apiSandbox("get","/api/v1/:model/search?term=&results_per_page=")

This would result in a form with three fields, one for `:model`, one for `term`, and one for `results_per_page`.

Inspiration
-----------

The API Sandbox plugin was inspired by [Wordnik's excellent API explorer](http://developer.wordnik.com/docs). To easily create an API for your Ruby on Rails web app, use [Grape](https://github.com/intridea/grape) -- this plugin was tested on an API using Grape.

TODO
----

* Fix bug that improperly splices user-entered param values when one param contains the text of another param (e.g. `results_per_page` and `page`).
* Add support for the entry of multiple values for array params (e.g. `?names[]=`).